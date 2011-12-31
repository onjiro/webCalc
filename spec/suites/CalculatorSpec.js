describe("Calculator", function() {
    it("display '0' after init", function() {
        calc = new Calculator();
        expect(calc.display()).toBe("0");
    });
    it("display '1' after entry '1'", function() {
        calc = new Calculator();
        calc.entry("1");
        expect(calc.display()).toBe("1");
    });
    it("display '10' after entry '1' and '0'", function() {
        calc = new Calculator();
        calc.entry("1");
        expect(calc.display()).toBe("1");
        calc.entry("0");
        expect(calc.display()).toBe("10");
    });
});
