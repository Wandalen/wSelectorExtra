
let _ = require( 'wselectorextra' );

/**/

var src = { a : [ 1, 2, 3 ], b : { b1 : 'x' }, c : 'test' }
var got = _.entityProbe({ src });

console.log( got.report );
/*
Probe : 3
*/
