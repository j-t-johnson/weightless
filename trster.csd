<CsoundSynthesizer>
<CsOptions>
-odac -d
</CsOptions>
<CsInstruments>

sr = 44100
ksmps = 32
nchnls = 2
0dbfs = 1

giwave ftgen 0, 0, 16384, 11, 5, 1, .3

instr 1

	aenv linsegr 0, 0.01, 0, 8, 1, 1, 0, 1, 0
	arise linseg p5, 0.01, p5, 3, p5 * semitone(1)

	asig oscil p4 * aenv, cpsmidinn(p5 - 12) + semitone(arise), giwave

	outs asig, asig
endin

</CsInstruments>
<CsScore>

i1 0 10 0.2 40

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
