( function _SelectorExtra_s_()
{

'use strict';

/**
 * Collection of cross-platform routines to select a sub-structure from a complex data structure. The module extends module Selector.
  @module Tools/base/SelectorExtra
  @extends Tools
*/

/**
 *  */

/**
  Collection of cross-platform routines to select a sub-structure from a complex data structure.
*/

if( typeof module !== 'undefined' )
{

  const _ = require( '../../../node_modules/Tools' );

  _.include( 'wSelector' );

}

const _global = _global_;
const _ = _global_.wTools;

_.assert( !!_realGlobal_ );

// --
// routine
// --

function _entityProbeReport( o )
{

  o = _.routine.options_( _entityProbeReport, o );
  _.assert( _.object.isBasic( o.result ) );
  _.assert( arguments.length === 1 );

  /* log */

  if( o.log )
  {
    if( !_.strIs( o.log ) )
    o.log = '';
    o.log += o.title + ' : ' + o.total + '\n';
    for( let r in o.result )
    {
      let d = o.result[ r ];
      o.log += o.tab;
      if( o.prependingByAsterisk )
      o.log += '*.';
      o.log += r + ' : ' + d.having.length;
      if( d.values )
      o.log += ' ' + _.entity.exportStringDiagnosticShallow( d.values );
      o.log += '\n';
    }
  }

  return o.log;
}

_entityProbeReport.defaults =
{
  title : null,
  log : null,
  result : null,
  total : null,
  prependingByAsterisk : 1,
  tab : '  ',
}

//

/**
 * @summary Investigates sub-structures of source entity `o.src`.
 * @param {Object} o Options map. See {@link module:Tools/base/Selector.wTools(module:Selector).select select} for options details.
 * @param {Boolean} o.log=1 Supplements result with info about sub-structures.
 * @param {String} o.title Title of log string. By default uses value of `o.selector`.
 * @function entityProbeField
 * @namespace Tools
 * @module Tools/base/SelectorExtra
*/

function entityProbeField( o )
{

  if( arguments[ 1 ] !== undefined )
  {
    o = Object.create( null );
    o.src = arguments[ 0 ];
    o.selector = arguments[ 1 ];
  }

  _.routine.options_( entityProbeField, o );

  _.assert( arguments.length === 1 || arguments.length === 2 );
  o.all = _.select( _.mapOnly_( null, o, _.select.defaults ) );
  o.onElement = function( it ){ return it.up };
  o.parents = _.select( _.mapOnly_( null, o, _.select.defaults ) );
  o.result = Object.create( null );

  /* */

  for( let i = 0 ; i < o.all.length ; i++ )
  {
    let val = o.all[ i ];
    if( !o.result[ val ] )
    {
      let d = o.result[ val ] = Object.create( null );
      d.having = [];
      d.notHaving = [];
      d.value = val;
    }
    let d = o.result[ val ];
    d.having.push( o.parents[ i ] );
  }

  for( let k in o.result )
  {
    let d = o.result[ k ];
    for( let i = 0 ; i < o.all.length ; i++ )
    {
      let element = o.all[ i ];
      let parent = o.parents[ i ];
      if( !_.longHas( d.having, parent ) )
      d.notHaving.push( parent );
    }
  }

  /* */

  if( o.log )
  {
    if( o.title === null )
    o.title = o.selector;
    o.log = _._entityProbeReport
    ({
      title : o.title,
      log : o.log,
      result : o.result,
      total : o.all.length,
      prependingByAsterisk : 0,
    });
  }

  return o;
}

entityProbeField.defaults = Object.create( _.select.defaults );
entityProbeField.defaults.title = null;
entityProbeField.defaults.log = 1;

//

/**
 * @summary Investigates sub-structures of source entity `o.src`.
 * @param {Object} o Options map
 * @param {*} o.src=null Source entity
 * @param {Object} o.result=null Map with results of processing of each sub-strucrute.
 * @param {Boolean} o.recursive=0 Enables recursive walkthrough
 * @param {Boolean} o.log=1 Supplements result with info about sub-structures.
 * @param {Number} o.total=0 Number of found sub-structures
 * @param {Array} o.all=null Array with found sub-structures
 * @param {String} o.title='Probe' Title of log string
 * @example
 *
 * let src = { a : { b : 1 }, c : { d : 2 } };
 * let r = _.entityProbe({ src, recursive : 1 });
 * console.log( r.log )
 * //Probe : 2
 * //*.b : 1 [ Array with 1 elements ]
 * //*.d : 1 [ Array with 1 elements ]
 *
 * @function entityProbe
 * @namespace Tools
 * @module Tools/base/SelectorExtra
*/

function entityProbe( o )
{

  if( _.arrayIs( o ) )
  o = { src : o }

  _.assert( arguments.length === 1, 'Expects single argument' );
  _.routine.options_( entityProbe, o );
  _.assert( _.arrayIs( o.src ) || _.object.isBasic( o.src ) );

  o.result = o.result || Object.create( null );
  o.all = o.all || [];

  /* */

  _.container.map_( null, o.src, function( src, k )
  {

    o.total += 1;

    // if( !_.longIs( src ) || !o.recursive )
    if( !_.longIs( src ) && o.recursive )
    {
      _.assert( _.object.isBasic( src ) );
      if( src !== undefined )
      extend( o.result, src );
      return src;
    }

    for( let s = 0 ; s < src.length ; s++ )
    {
      if( _.arrayIs( src[ s ] ) )
      entityProbe
      ({
        src : src[ s ],
        result : o.result,
        allowingCollision : o.allowingCollision,
      });
      else if( _.object.isBasic( src[ s ] ) )
      extend( o.result, src );
      // else
      // throw _.err( 'Array should have only maps' );
    }

    return src;
  });

  /* not having */

  for( let a = 0 ; a < o.all.length ; a++ )
  {
    let map = o.all[ a ];
    for( let r in o.result )
    {
      let field = o.result[ r ];
      if( !_.longHas( field.having, map ) )
      field.notHaving.push( map );
    }
  }

  if( o.log )
  o.log = _._entityProbeReport
  ({
    title : o.title,
    log : o.log,
    result : o.result,
    total : o.total,
    prependingByAsterisk : 1,
  });

  return o;

  /* */

  function extend( result, src )
  {

    o.all.push( src );

    if( !o.allowingCollision )
    _.map.assertHasNone( result, src );

    for( let s in src )
    {
      if( !result[ s ] )
      {
        let r = result[ s ] = Object.create( null );
        r.times = 0;
        r.values = [];
        r.having = [];
        r.notHaving = [];
      }
      let r = result[ s ];
      r.times += 1;
      let added = _.arrayAppendedOnce( r.values, src[ s ] ) !== -1;
      r.having.push( src );
    }

  }

}

entityProbe.defaults =
{
  src : null,
  result : null,
  recursive : 0,
  log : 1,
  total : 0,
  all : null,
  title : 'Probe',
}

// --
// declare
// --

let Proto =
{

  _entityProbeReport,
  entityProbeField,
  entityProbe,

}

_.props.supplement( _, Proto );

// --
// export
// --

if( typeof module !== 'undefined' )
module[ 'exports' ] = _;

})();
