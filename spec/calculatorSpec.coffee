{Calculator} = require("../src/calculator")

describe "Calculator", ->
  calc = null

  beforeEach ->
    calc = new Calculator()

  it "初期化時には 0 が表示されていること", ->
    expect(calc.display()).toBe "0"

  it "複数桁の数値が入力できること", ->
    expect(calc.entry("1").display()).toBe "1"
    expect(calc.entry("0").display()).toBe "10"

  it "単純な足し算ができること", ->
    expect(calc.entry("1").entry("+").display()).toBe "1"
    expect(calc.entry("2").display()).toBe "2"
    expect(calc.entry("=").display()).toBe "3"

  it "'='の入力なしに連続して計算が可能なこと", ->
    expect(calc.entry("1").entry("+").entry("2").entry("-").display()).toBe "3"
    expect(calc.entry("4").entry("=").display()).toBe "-1"

  it "計算実施後に新たな計算が開始できること", ->
    expect(calc.entry("3").entry("-").entry("2").entry("=").display()).toBe "1"
    expect(calc.entry("1").display()).toBe "1"
    expect(calc.entry("2").display()).toBe "12"
    expect(calc.entry("+").display()).toBe "12"
    expect(calc.entry("3").display()).toBe "3"
    expect(calc.entry("=").display()).toBe "15"

  it "計算後は数値+'='を入力することで定数計算が可能なこと。後に入力した数値が定数として使用される", ->
    expect(calc.entry("6").entry("/").entry("2").entry("=").display()).toBe "3"
    expect(calc.entry("8").display()).toBe "8"
    expect(calc.entry("=").display()).toBe "4"

  it "'='を連続して入力することで、続けての定数計算が可能なこと", ->
    expect(calc.entry("6").entry("+").entry("2").entry("=").display()).toBe "8"
    expect(calc.entry("=").display()).toBe "10"
    expect(calc.entry("=").display()).toBe "12"

  it "掛け算の定数計算の場合は先に入力した数値が定数として使用されること", ->
    expect(calc.entry("2").entry("*").entry("3").entry("=").display()).toBe "6"
    expect(calc.entry("4").display()).toBe "4"
    expect(calc.entry("=").display()).toBe "8"

  it "一度も計算を実施していない場合、定数計算が使用できないこと", ->
    expect(calc.entry("=").display()).toBe "0"
    expect(calc.entry("1").display()).toBe "1"
    expect(calc.entry("=").display()).toBe "1"
    expect(calc.entry("2").display()).toBe "2"
    expect(calc.entry("=").display()).toBe "2"
