( function _SelectorExtra_test_s_()
{

'use strict';

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wTesting' );
  _.include( 'wLogger' );

  require( '../l6/SelectorExtra.s' );

}

const _global = _global_;
const _ = _global_.wTools;

// --
// tests
// --

function entityProbe( test )
{

  var src = { a : [ 1, 2, 3 ], b : { b1 : 'x' }, c : 'test' }
  var expected = null;
  var got = _.entityProbe({ src });
  test.identical( got.log, 'Probe : 3\n' );

  var src = [ [ 1, 2, 3 ], { b1 : 'x' }, 'test' ]
  var expected = null;
  var got = _.entityProbe({ src });
  test.identical( got.log, 'Probe : 3\n' );

}

// --
// declare
// --

const Proto =
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

const Self = wTestSuite( Proto );
if( typeof module !== 'undefined' && !module.parent )
wTester.test( Self.name );

})();
