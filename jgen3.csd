<CsoundSynthesizer>
<CsOptions>
-odac -dm0
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 128
nchnls = 2
0dbfs = 1

;//////////////////////////////////////////////////////////

ginotesb ftgen 0, 0, 4, -2, 48, 50, 56, 60

giwave ftgen 0, 0, 16384, 11, 5, 1, .6

gibuffer ftgen 0, 0, 2^18, 7, 0
giwindow ftgen 0, 0, 512, 20, 5, 1

gaverbL init 0
gaverbR init 0
gawrite init 0

gkwarble rspline -2, 2, 0.01, 0.7

;//////////////////////////////////////////////////////////

seed 0

turnon "makenotes"
turnon "verb"
turnon "writebuffer"
turnon "readbuffer", 5

maxalloc "bowedbar", 10
maxalloc "writebuffer", 1
maxalloc "readbuffer", 1

;/ generate notes /////////////////////////////////////////

instr makenotes

	kcounter init 0
	kresetcounter init 0
	ireset random 6, 10
	
	krisetirg init 0
	
	irise random 30, 60
	
	knrand random 0, 3

	itrans random 0, 11
	
	katt rspline 0.1, 0.8, 0.17, 3.19
	kp rspline 0.9, 1.1, 0.457, 2.39

	knoteb table knrand, ginotesb
	knoteb = knoteb - itrans

	kmod rspline -1, 2, 0.0613, 5
	ktrigb metro (kr/500) + kmod
	if (ktrigb == 1) then
		kcounter = kcounter + 1
	endif
	
	if (kcounter > irise) then
		krisetirg = 1
	endif

	knoter table knrand, ginotesb
	knoter = knoter - itrans
		
	ktrigr metro (kr/4950) 
	kampr rspline 0.015, 0.3, 0.05, 2

	if (krisetirg == 1) then
		
		schedkwhennamed ktrigr, 0, 0, "rise", 0, 10, kampr, knoter
	endif

	schedkwhennamed ktrigb, 0, 0, "bowedbar", 0, 5, .5, knoteb, kp, katt
	
	if (ktrigr == 1 && krisetirg == 1) then
		kresetcounter = kresetcounter + 1
	endif
	if (kresetcounter > ireset) then
			kcounter = 0
			kresetcounter = 0
			krisetirg = 0
			
	endif

	printk2 kresetcounter
	printk2 krisetirg
	print ireset

endin

;/ rise //////////////////////////////////////////////

instr rise

	irand random 0, 1
	irand = (floor(irand)) - 1

	aenv linsegr 0, 0.01, 0, 5, 1, 1, 0, 1, 0
	arise linseg p5, 0.01, p5, 3, p5 * semitone(irand)

	asig oscil p4 * aenv, cpsmidinn(p5 - 24) + semitone(arise), giwave

	outs asig, asig
	
	gaverbL = asig * 0.45
	gaverbR = asig * 0.45

endin


;/ bowed bar //////////////////////////////////////////////

instr bowedbar

	iatt = p7
	aenv linsegr 0, 0.05, 0, 0.5, 1, 4, 0, 0.1, 0
	
	kp   = p6
	asig wgbowedbar p4, cpsmidinn(p5) + semitone(gkwarble), 1, kp, 0.995
	asig buthp asig, 200
	asig butlp asig, 1000
	asig = asig * aenv

	gawrite = asig

endin

;/ write buffer ///////////////////////////////////////////

instr writebuffer

	iftlen = ftlen(gibuffer)
	itime = 1 / (iftlen / 44100)

	awrite phasor itime
	tablew gawrite, (awrite*iftlen) + 1, gibuffer
	clear gawrite

endin

;/ granular ////////////////////////////////////////////////

instr readbuffer

	kwarble jspline 2, 0.025, 0.35
	kwarble = kwarble - 1

	;grain amp
	kamp = 1

	;grain pitch (buffer sample rate / length of buffer = og pitch)
	kpitch1 = ((sr/ftlen(gibuffer)) + kwarble)
	kpitch2 = ((sr/ftlen(gibuffer))*2 + kwarble)
	kpitch3 = ((sr/ftlen(gibuffer))*4 + kwarble)

	;grain density (grains per second)
	kdens1 jitter 0.15, 0.07, 1
	kdens1 = kdens1 + 0.25

	kdens2 jitter 0.15, 0.5, 2
	kdens2 = kdens2 + 0.2

	kdens3 jitter 0.05, 0.1, 3
	kdens3 = kdens3 + 0.15

	;amplitude variation
	kampoff = 1

	;pitch variation (hz)
	kpitchoff = 0.5

	;grain duration
	kgdur rspline 0.8, 2, 0.07, 1

	;grain buffer
	igfn = gibuffer

	;windowing envelope
	iwfn = giwindow

	;max grain duration
	imgdur = 2

	agrain1 grain kamp, kpitch1, kdens1, kampoff, kpitchoff, kgdur, igfn, iwfn, imgdur
	agrain2 grain kamp, kpitch2, kdens2, kampoff, kpitchoff, kgdur, igfn, iwfn, imgdur
	agrain3 grain kamp, kpitch3, kdens3, kampoff, kpitchoff, kgdur, igfn, iwfn, imgdur

	kpan1 rspline 0, 1, 0.1, 7
	kpan2 rspline 0, 1, 0.1, 7
	kpan3 rspline 0, 1, 0.1, 7

	a1, a2 pan2 agrain1, kpan1
	a3, a4 pan2 agrain2, kpan2
	a5, a6 pan2 agrain3, kpan3

	ao1 = a1 + a3 + a5
	ao2 = a2 + a4 + a6

	outs ao1, ao2
	gaverbL = gaverbL + (ao1 * 0.8)
	gaverbR = gaverbR + (ao2 * 0.8)

endin

;/ reverb ///////////////////////////////////////////////

instr verb
	aL, aR reverbsc gaverbL, gaverbR, 0.94, 7500
	outs aL, aR
	clear gaverbL, gaverbR
endin

;//////////////////////////////////////////////////////////

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
