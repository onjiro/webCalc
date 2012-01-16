{exec} = require "child_process"
fs = require "fs"
{join, existsSync} = require "path"
watch = require "nodewatch"

DEST = "js/webCalc.js"
SRCDIR = "src"

task "build", "src をビルドして webCalc.js を生成します", (options)->
  srcs = []
  crowl SRCDIR, (filepath)->
    srcs.push filepath if filepath.match /[~#]*\.coffee$/
  exec "coffee -cj #{DEST} #{srcs.join ' '}", endwith (err, stdout, stderr)->
    console.log "succeed to build '#{DEST}'" unless stderr

task "clean", "build によって生成されるファイルを削除します", (options)->
  exec "rm #{DEST}", endwith(->console.log "succeed to clean") if existsSync DEST

task "test", "src が spec を満たしているかのテストを実施します", (options)->
  exec "jasmine-node --coffee spec", endwith()

task "watch", "src, spec に変更がある度にビルド、テストを実行します", (options)->
  console.log "start watching ..."
  watch.add("src").add("spec").onChange (path, prev, curr)->
    console.log "detected changes on #{path}"
    doSerial(-> invoke "build")
      .with(-> invoke "test")
      .with(-> console.log "build end now").call()

# exec 完了時のコールバック用関数生成関数
endwith = (yield)->
  return (err, stdout, stderr)->
    yield(err, stdout, stderr) if yield
    console.error err.message if err
    console.log stdout if stdout
    console.error stderr if stderr

# filepath 以下を走査して各ディレクトリ、ファイルのパスを引数に yield を実行する関数
crowl = (filepath, yield) ->
  yield filepath
  if fs.lstatSync(filepath).isDirectory()
    files = (join(filepath, filename) for filename in fs.readdirSync(filepath))
    crowl(newpath, yield) for newpath in files

nextTick = (callback)->
  setTimeout callback, 0

# 指定された関数を順次実行させるオブジェクトを生成します
doSerial = (f)->
  queue = [f]
  return {
    with: (f)->
      queue.push f
      this
    call: ->
      serialQueue = []
      queue.reverse()
      serializer = null
      for f, i in queue
        do (f, i) ->
          serialQueue.push ->
            proc = f()
            proc.on("exit", serialQueue.pop()) unless serialQueue.length <= 0
      queue.reverse()
      serialQueue.pop()()
    }
