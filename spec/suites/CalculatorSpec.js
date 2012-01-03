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
});
