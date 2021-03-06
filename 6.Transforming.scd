/*
- An implementation in SuperCollider of Tom Johnson's techniques, as described in the "Self-Similar Melodies" book -
by Darien Brito (2015)
http://www.darienbrito.com

This work is licensed under Creative Commons
Attribution-NonCommercial-ShareAlike 4.0 International Licence (CC BY-NC-SA 4.0)

To view a copy of this license go to:
http://creativecommons.org/licenses/by-nc-sa/4.0/
*/

/*______________________________________________________________

                     Transforming
________________________________________________________________*/


/*_______________________

Constants
_________________________*/

//Test sound:
(
SynthDef(\sine, {|freq = 440, amp = 0.1, rel = 0.8|
	var sig = SinOsc.ar(freq, 0, amp);
	var env = EnvGen.kr(Env.perc(releaseTime: rel),doneAction:2);
	sig = sig*env;
	Out.ar(0, sig!2)
}).add;

// Parameters
~scale = Scale.minor;
~amp = Pfunc({ |ev| if(ev.degree < 1) { 0.1 } { ev.degree.reciprocal * 0.25}} );
)


// Automata generator with arbitrary rules (run this first)

(
~automataGenerator = { | one, zero, start, numTests | //Arrays
	var seq = List[start];
	numTests.do{ |i|
		if(seq[i] == 1) {
			one.do{|item| seq.add(item)};
		} {
			zero.do{|item| seq.add(item)};
		}
	};
	seq;
})

// Test
//~automataGenerator.value([1,0],[0,1],1, 10)

/*______________________

 Simple automaton I
________________________*/

1->10
0->01

(
var numTests = 10; // Number of tests
var dur = 0.15;
var startingPoint = 0;
var seq = ~automataGenerator.value( [1,0], [0,1], startingPoint, numTests);
var temp;

//Transform sequence into 1, -1
seq = seq.asArray.replace([0],-1);
p = Pbindef(\transform1,
	\instrument, \sine,
	\scale, ~scale,
    \dummy, Pseries(0,1,inf),
	\degree, Pfunc({|ev|
		temp = startingPoint + seq.wrapAt(ev.dummy);
		startingPoint = temp;
	}),
	\octave, 6,
	\recorder, Pfunc({ |ev| ~sequence.add(ev.degree) }), // To store the resulting sequence
	\amp, ~amp, // To compensate for higher frequencies perceived as louder
	\dur, dur
).quant_(0).play
)

/*______________________

 Simple automaton II
________________________*/


1 -> 0
0 -> 0 0 1

(
var numTests = 10; // Number of tests
var dur = 0.15;
var startingPoint = 0; //Fundamental
var seq = ~automataGenerator.value( [0], [0,0,1], startingPoint, numTests); // Rule change
var temp;
//Transform sequence into 1, -1
seq = seq.asArray.replace([0],-1);
p = Pbindef(\transform2,
	\instrument, \sine,
	\scale, ~scale,
    \dummy, Pseries(0,1,inf),
	\degree, Pfunc({|ev|
		temp = startingPoint + seq.wrapAt(ev.dummy);
		startingPoint = temp;
	}),
	\recorder, Pfunc({ |ev| ~sequence.add(ev.degree) }), // To store the resulting sequence
	\amp, ~amp, // To compensate for higher frequencies perceived as louder
	\dur, dur
).quant_(0).play
)


/*______________________

 Simple automaton III
________________________*/


1 -> 0
0 -> 0 1 1

(
var numTests = 10; // Number of tests
var dur = 0.15;
var startingPoint = 0; //Fundamental
var seq = ~automataGenerator.value( [0], [0,1,1], startingPoint, numTests ); // Rule change
var temp;
//Transform sequence into 1, -1
seq = seq.asArray.replace([0],-1);
p = Pbindef(\transform3,
	\instrument, \sine,
	\scale, ~scale,
    \dummy, Pseries(0,1,inf),
	\degree, Pfunc({|ev|
		temp = startingPoint + seq.wrapAt(ev.dummy);
		startingPoint = temp;
	}),
	\recorder, Pfunc({ |ev| ~sequence.add(ev.degree) }), // To store the resulting sequence
	\amp, ~amp, // To compensate for higher frequencies perceived as louder
	\dur, dur
).quant_(0).play
)


/*______________________

 Simple automaton IV
________________________*/


1 -> 1 0 1
0 -> 0 0

(
var numTests = 10; // Number of tests
var dur = 0.15;
var startingPoint = 0; //Fundamental
var seq = ~automataGenerator.value( [0], [0,1,1], startingPoint, numTests ); // Rule change
var temp;
//Transform sequence into 1, -1
seq = seq.asArray.replace([0],-1);
p = Pbindef(\transform1,
	\instrument, \sine,
	\scale, ~scale,
    \dummy, Pseries(0,1,inf),
	\degree, Pfunc({|ev|
		temp = startingPoint + seq.wrapAt(ev.dummy);
		startingPoint = temp;
	}),
	\recorder, Pfunc({ |ev| ~sequence.add(ev.degree) }), // To store the resulting sequence
	\amp, ~amp, // To compensate for higher frequencies perceived as louder
	\dur, dur
).quant_(0).play
)


// Calculate the number of elements per row with a function xn = 2xn + 1 + xn
(~rowCalculator = { | rowNumber |
	var result;
	result = ((2 * rowNumber) + 1)  + rowNumber;
})
~rowCalculator.value(3)
