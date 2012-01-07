sys = require "util"
{exec} = require "child_process"
fs = require "fs"
{join, existsSync} = require "path"

DEST = "js/webCalc.js"
SRCDIR = "src"

task "build", "src をビルドして webCalc.js を生成します", (options)->
  srcs = []
  crowl SRCDIR, (filepath)->
    srcs.push filepath if filepath.match /.*\.coffee/
  exec "coffee -cj #{DEST} #{srcs.join ' '}", endwith (err, stdout, stderr)->
    console.log "succeed to build '#{DEST}'" unless stderr

task "clean", "build によって生成されるファイルを削除します", (options)->
  exec "rm #{DEST}", endwith(->console.log "succeed to clean") if existsSync DEST

task "test", "src が spec を満たしているかのテストを実施します", (options)->
  exec "jasmine-node --coffee spec", endwith()

# exec 完了時のコールバック用関数生成関数
endwith = (yield)->
  return (err, stdout, stderr)->
    yield(err, stdout, stderr) if yield
    throw err if err
    console.log "#{stdout} #{stderr}" if (stdout or stderr)

# filepath 以下を走査して各ディレクトリ、ファイルのパスを引数に yield を実行する関数
crowl = (filepath, yield) ->
  yield filepath
  if fs.lstatSync(filepath).isDirectory()
    files = (join(filepath, filename) for filename in fs.readdirSync(filepath))
    crowl(newpath, yield) for newpath in files
