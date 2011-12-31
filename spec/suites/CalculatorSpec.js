describe("Calculator", function() {
    it("display '0' after init", function() {
        calc = new Calculator();
        expect(calc.display()).toBe("0");
    });
    it("display '1' after entry '1'", function() {
        calc = new Calculator();
        expect(calc.entry("1").display()).toBe("1");
    });
    it("display '10' after entry '1' and '0'", function() {
        calc = new Calculator();
        expect(calc.entry("1").display()).toBe("1");
        expect(calc.entry("0").display()).toBe("10");
    });
    
    it("display '1' after entry '1' and '+'", function() {
        calc = new Calculator();
        expect(calc.entry("1").entry("+").display()).toBe("1");
    });
    it("display '2' after entry '1', '+' and '2'", function() {
        calc = new Calculator();
        expect(calc.entry("1").entry("+").entry("2").display()).toBe("2");
    });
    it("display '3' after entry '1', '+', '2' and '='", function() {
        calc = new Calculator();
        expect(calc.entry("1").entry("+").entry("2").entry("=").display()).toBe("3");
    });
});
