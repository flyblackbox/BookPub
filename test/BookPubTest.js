var BookPub = artifacts.require("./BookPub.sol");
contract('BookPub', function(accounts) {
it("creates a book with readerstake of 1 ", function() {
	var N=1;
    var instance;
    return BookPub.new( {
      from: accounts[0],
       }) 
        .then(_instance => {
            instance = _instance;
           return instance.publishBook(1,"MYBOOK","BK","boardroom");
        })
        .then(() =>{
            
            return instance.StructRet.call(1);
        })     
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), N, "Readershipstake should be 1");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});
it("creates a book with a tokenname of MYBOOK", function() {
	var Name="MYBOOK";
    var instance;
    return BookPub.new( {
      from: accounts[0],
       }) 
        .then(_instance => {
            instance = _instance;
           return instance.publishBook(1,"MYBOOK","BK","boardroom");
        })
        .then(() =>{
            
            return instance.nameret.call(1);
        })     
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), Name, "tokenname should be MYBOOK");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});
it("creates a book with a tokensymbol of BK", function() {
	var Symbol="BK";
    var instance;
    return BookPub.new( {
      from: accounts[0],
       }) 
        .then(_instance => {
            instance = _instance;
            return instance.publishBook(1,"MYBOOK","BK","boardroom");
        })
        .then(() =>{
            
            return instance.symbolret.call(1);
        })     
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), Symbol, " symbol should be BK");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});		
it(" BOOKID will increment with iterate with function call", function() {
	var Symbol="BKK";
    var instance;
    return BookPub.new( {
      from: accounts[0],
       }) 
        .then(_instance => {
            instance = _instance;
            return instance.publishBook(1,"MYBOOK","BK","boardroom");
        }).then(() =>{
            
             return instance.publishBook(1,"MYBOOK","BKK","boardroom");
        }).then(() =>{
            
            return instance.symbolret.call(2);
        })     
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue.toString(), Symbol, " symbol should be BK");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});
	it(" Partner ID of 12 should be added", function() {
	var ID=12;
    var instance;
    return BookPub.new( {
      from: accounts[0],
       }) 
        .then(_instance => {
            instance = _instance;
            return instance.publishBook(1,"MYBOOK","BK","boardroom");
        }).then(() =>{
            
             return instance.addPartner(1,12,10);
        }).then(() =>{
            
            return instance.partner.call(1,0);
        })     
        .then(resultValue => {
		    console.log(resultValue);
            assert.equal(resultValue, ID , " ID should be 12");
            // Do not return anything on the last callback or it will believe there is an error.
        });
});			
	
	
	
	
	
});