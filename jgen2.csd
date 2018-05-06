<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

;/ftables////////////////////////////////////////////////

ginotes ftgen 1, 0, 4, -2, 60, 62, 70, 72 
gibuffer ftgen 100, 0, 2^18, 7, 0
giwindow ftgen 200, 0, 512, 20, 6, 1

;/globals////////////////////////////////////////////////

gaverb init 0
gawrite init 0

;/instrument management//////////////////////////////////

turnon "makenotes"
turnon "verb"
turnon "writebuffer"
turnon "readbuffer", 5

maxalloc "string", 10
maxalloc "writebuffer", 1
maxalloc "readbuffer", 1

;/generate notes/////////////////////////////////////////

instr makenotes
	
	krand rand 2
	krand = floor(krand + 2)
	
	knote table krand, ginotes
	knote = knote - 2
	
	kmod oscil 3, 0.1
	kmod = kmod + 3
	
	ktrig metro (kr/500) + kmod
	
	if (ktrig == 1) then
		schedkwhennamed ktrig, 0, 0, "string", 0, 5, knote
	endif
	
endin

;/string instrument//////////////////////////////////////

instr string

	avibenv linsegr 0, 1, 3 
	avib oscil avibenv, 4.7
	kvib downsamp avib

	kpch = cpsmidinn(p4)

	ipch = p4

	aenv linsegr 0, 0.3, 1, 0.1, 0

	asig pluck 0.2, kpch+kvib, ipch, 0, 1
	asig moogladder asig, 6000, 0.15
	asig pareq asig, 2000, 0.01, sqrt(.5), 2
	asig = asig * aenv
	
	gawrite = asig
	
	gaverb = gaverb + (asig * 0.6)
	outs asig, asig

endin

;/write buffer///////////////////////////////////////////

instr writebuffer
	
	iftlen = ftlen(100)
	itime = 1 / (iftlen / 44100)
	
	awrite phasor itime
	tablew gawrite, awrite*iftlen, gibuffer
	clear gawrite
	
endin

;/read buffer////////////////////////////////////////////

instr readbuffer

	;grain amp 

	adens1 oscil 0.5, 2.61
	adens1 = adens1 + 0.25

	adens2 oscil 0.5, 3.14
	adens2 = adens2 + 0.25


	adens3 oscil 0.5, 1.91
	adens3 = adens3 + 0.25	
	
	adens4 oscil 0.5, 4.07
	adens4 = adens4 + 0.25
	
	kamp1 downsamp adens1
	

	kamp2 downsamp adens2
	

	kamp3 downsamp adens3
	

	kamp4 downsamp adens4
	
	
	;grain pitch (buffer sample rate / length of buffer = og pitch)
	kpitch1 = (sr/ftlen(100))*2
	kpitch2 = (sr/ftlen(100))*4
	
	;grain density (grains per second)
	kdens = 10


	
	;amplitude variation
	kampoff = 0.2
	
	;pitch variation (hz)
	kpitchoff = 0
	
	;grain duration
	kgdur = 1
	
	;grain buffer
	igfn = gibuffer
	
	;windowing envelope
	iwfn = giwindow
	
	;max grain duration
	imgdur = 1
	
	agrain1 grain kamp1, kpitch1, kdens, kampoff, kpitchoff, kgdur, igfn, iwfn, imgdur
	agrain2 grain kamp2, kpitch1, kdens, kampoff, kpitchoff, kgdur, igfn, iwfn, imgdur
	agrain3 grain kamp3, kpitch2, kdens, kampoff, kpitchoff, kgdur, igfn, iwfn, imgdur
	agrain4 grain kamp4, kpitch2, kdens, kampoff, kpitchoff, kgdur, igfn, iwfn, imgdur
	
	outs agrain1 + agrain3, agrain2 + agrain4
	gaverb = gaverb + (agrain1 * 0.8) + (agrain2 * 0.8) + (agrain3 * 0.8) + (agrain4 * 0.8)
	
endin

;/reverb/////////////////////////////////////////////////

instr verb
	aL, aR reverbsc gaverb, gaverb, 0.88, 8000
	outs aL, aR
	clear gaverb
endin

;////////////////////////////////////////////////////////
;////////////////////////////////////////////////////////

</CsInstruments>
<CsScore>

</CsScore>
</CsoundSynthesizer>
<bsbPanel>
 <label>Widgets</label>
 <objectName/>
 <x>100</x>
 <y>100</y>
 <width>320</width>
 <height>240</height>
 <visible>true</visible>
 <uuid/>
 <bgcolor mode="nobackground">
  <r>255</r>
  <g>255</g>
  <b>255</b>
 </bgcolor>
</bsbPanel>
<bsbPresets>
</bsbPresets>
