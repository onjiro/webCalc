describe("Calculator", function() {
    it("初期化時には 0 が表示されていること", function() {
        calc = new Calculator();
        expect(calc.display()).toBe("0");
    });
    it("複数桁の数値が入力できること", function() {
        calc = new Calculator();
        expect(calc.entry("1").display()).toBe("1");
        expect(calc.entry("0").display()).toBe("10");
    });
    it("単純な足し算ができること", function() {
        calc = new Calculator();
        expect(calc.entry("1").entry("+").display()).toBe("1");
        expect(calc.entry("2").display()).toBe("2");
        expect(calc.entry("=").display()).toBe("3");
    });
    it("'='の入力なしに連続して計算が可能なこと", function() {
        calc = new Calculator();
        expect(calc.entry("1").entry("+").entry("2").entry("-").display()).toBe("3");
        expect(calc.entry("4").entry("=").display()).toBe("-1");
    });
    it("計算後は数値+'='を入力することで定数計算が可能なこと。後に入力した数値が定数として使用される", function() {
        calc = new Calculator();
        expect(calc.entry("6").entry("/").entry("2").entry("=").display()).toBe("3");
        expect(calc.entry("8").display()).toBe("8");
        expect(calc.entry("=").display()).toBe("4");
    });
    it("掛け算の定数計算の場合は先に入力した数値が定数として使用されること", function() {
        calc = new Calculator();
        expect(calc.entry("2").entry("*").entry("3").entry("=").display()).toBe("6");
        expect(calc.entry("4").display()).toBe("4");
        expect(calc.entry("=").display()).toBe("8");
    });
});
