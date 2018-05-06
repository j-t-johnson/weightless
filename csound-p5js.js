//jacob johnson
//web csound
//adapted from Steven Yi's "Glowing Orbs Example"

//globals tied to sketch.js
var csoundLoaded = false;
var cs = null;

//load csound after WebAssembly initializes
function onRuntimeInitialized() {
  var csd = new XMLHttpRequest();

  csd.open('GET', "jgen3.csd", true);
  csd.onreadystatechange = function() {
    //txt is the actual code from the csd
    var txt = csd.responseText;

    var finishLoadCsObj = function() {
      cs = new CsoundObj();
      cs.setOption("-m0");
      cs.compileCSD(txt);

      cs.start();
      cs.audioContext.resume();
      csoundLoaded = true;
    }
    finishLoadCsObj();
  }
  csd.send();
}

function load_script(src, async) {
  var script = document.createElement('script');
  script.src = src;
  script.async = async;
  document.head.appendChild(script);
}

function wasmLog(msg) {
  console.log(msg);
}

// Initialize Module before WASM loads
Module = {};
Module['wasmBinaryFile'] = 'wasm/libcsound.wasm';
Module['print'] = wasmLog;
Module['printErr'] = wasmLog;
Module['onRuntimeInitialized'] = onRuntimeInitialized;

if(typeof WebAssembly !== undefined) {
  console.log("Using WASM Csound...");
  load_script("wasm/libcsound.js", false);
  load_script("wasm/FileList.js", false);
  load_script("wasm/CsoundObj.js", false);
}
