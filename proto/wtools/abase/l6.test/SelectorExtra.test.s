( function _SelectorExtra_test_s_() {

'use strict';

if( typeof module !== 'undefined' )
{

  let _ = require( '../../../wtools/Tools.s' );

  _.include( 'wTesting' );
  _.include( 'wLogger' );

  require( '../l6/SelectorExtra.s' );

}

let _global = _global_;
let _ = _global_.wTools;

// --
// tests
// --

function entityProbe( test )
{

  var src = { a : [ 1,2,3 ], b : { b1 : 'x' }, c : 'test' }
  var expected = null;
  var got = _.entityProbe({ src });
  test.identical( got.log, 'Probe : 3\n' );

  var src = [ [ 1,2,3 ], { b1 : 'x' }, 'test' ]
  var expected = null;
  var got = _.entityProbe({ src });
  test.identical( got.log, 'Probe : 3\n' );

}

// --
// declare
// --

let Self =
{

  name : 'Tools.l6.SelectorExtra',
  silencing : 1,
  enabled : 1,

  context :
  {
  },

  tests :
  {
    entityProbe,
  }

}

Self = wTestSuite( Self );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
