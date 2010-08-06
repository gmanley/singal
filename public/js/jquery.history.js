/*
 * jQuery history plugin
 * 
 * sample page: http://www.mikage.to/jquery/jquery_history.html
 *
 * Copyright (c) 2006-2009 Taku Sano (Mikage Sawatari)
 * Licensed under the MIT License:
 *   http://www.opensource.org/licenses/mit-license.php
 *
 * Modified by Lincoln Cooper to add Safari support and only call the callback once during initialization
 * for msie when no initial hash supplied.
 */

jQuery.extend({historyCurrentHash:undefined,historyCallback:undefined,historyIframeSrc:undefined,historyInit:function(callback,src){jQuery.historyCallback=callback;if(src)jQuery.historyIframeSrc=src;var current_hash=location.hash.replace(/\?.*$/,'');jQuery.historyCurrentHash=current_hash;if(jQuery.browser.msie){if(jQuery.historyCurrentHash==''){jQuery.historyCurrentHash='#';}
jQuery("body").prepend('<iframe id="jQuery_history" style="display: none;"'+
(jQuery.historyIframeSrc?' src="'+jQuery.historyIframeSrc+'"':'')
+'></iframe>');var ihistory=jQuery("#jQuery_history")[0];var iframe=ihistory.contentWindow.document;iframe.open();iframe.close();iframe.location.hash=current_hash;}
else if(jQuery.browser.safari){jQuery.historyBackStack=[];jQuery.historyBackStack.length=history.length;jQuery.historyForwardStack=[];jQuery.lastHistoryLength=history.length;jQuery.isFirst=true;}
if(current_hash)
jQuery.historyCallback(current_hash.replace(/^#/,''));setInterval(jQuery.historyCheck,100);},historyAddHistory:function(hash){jQuery.historyBackStack.push(hash);jQuery.historyForwardStack.length=0;this.isFirst=true;},historyCheck:function(){if(jQuery.browser.msie){var ihistory=jQuery("#jQuery_history")[0];var iframe=ihistory.contentDocument||ihistory.contentWindow.document;var current_hash=iframe.location.hash.replace(/\?.*$/,'');if(current_hash!=jQuery.historyCurrentHash){location.hash=current_hash;jQuery.historyCurrentHash=current_hash;jQuery.historyCallback(current_hash.replace(/^#/,''));}}else if(jQuery.browser.safari){if(jQuery.lastHistoryLength==history.length&&jQuery.historyBackStack.length>jQuery.lastHistoryLength){jQuery.historyBackStack.shift();}
if(!jQuery.dontCheck){var historyDelta=history.length-jQuery.historyBackStack.length;jQuery.lastHistoryLength=history.length;if(historyDelta){jQuery.isFirst=false;if(historyDelta<0){for(var i=0;i<Math.abs(historyDelta);i++)jQuery.historyForwardStack.unshift(jQuery.historyBackStack.pop());}else{for(var i=0;i<historyDelta;i++)jQuery.historyBackStack.push(jQuery.historyForwardStack.shift());}
var cachedHash=jQuery.historyBackStack[jQuery.historyBackStack.length-1];if(cachedHash!=undefined){jQuery.historyCurrentHash=location.hash.replace(/\?.*$/,'');jQuery.historyCallback(cachedHash);}}else if(jQuery.historyBackStack[jQuery.historyBackStack.length-1]==undefined&&!jQuery.isFirst){if(location.hash){var current_hash=location.hash;jQuery.historyCallback(location.hash.replace(/^#/,''));}else{var current_hash='';jQuery.historyCallback('');}
jQuery.isFirst=true;}}}else{var current_hash=location.hash.replace(/\?.*$/,'');if(current_hash!=jQuery.historyCurrentHash){jQuery.historyCurrentHash=current_hash;jQuery.historyCallback(current_hash.replace(/^#/,''));}}},historyLoad:function(hash){var newhash;hash=decodeURIComponent(hash.replace(/\?.*$/,''));if(jQuery.browser.safari){newhash=hash;}
else{newhash='#'+hash;location.hash=newhash;}
jQuery.historyCurrentHash=newhash;if(jQuery.browser.msie){var ihistory=jQuery("#jQuery_history")[0];var iframe=ihistory.contentWindow.document;iframe.open();iframe.close();iframe.location.hash=newhash;jQuery.lastHistoryLength=history.length;jQuery.historyCallback(hash);}
else if(jQuery.browser.safari){jQuery.dontCheck=true;this.historyAddHistory(hash);var fn=function(){jQuery.dontCheck=false;};window.setTimeout(fn,200);jQuery.historyCallback(hash);location.hash=newhash;}
else{jQuery.historyCallback(hash);}}});