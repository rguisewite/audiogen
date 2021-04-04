Audiogen - Python 3
========

The ``audiogen_p3`` package provides time domain audio processing tools
using Python generators. 

Please note, this is a forked repository from "audiogen" by user "casebeer"
updated to work with Python3 since the original package has been unmaintained
for a few years. The only modifications to this package were to allow use
in Python 3. The remainder of the code is all original work by Christopher H. Casebeer

To use audiogen_p3 in a more readable way and without changing existing
audiogen code, import audiogen_p3 this way:

    import audiogen_p3 as audiogen

This is required for the examples in the documentation.

If "AttributeError: module 'audiogen_p3' has no attribute 'mixer'",
skip past mixer examples to the audiogen.sampler.play examples. To
enable more features using optional dependencies, see the Installation
section.

This module makes some types of audio sample generation and processing pretty 
easy::

    # mix 440 Hz and 445 Hz tones to get 5 Hz beating
    beats = audiogen.mixer(
        (audiogen.tone(440), audiogen.tone(445)),
        [(constant(1), constant(1)),]
    )

The actual samples won't be generated or stored in memory until they're 
actually consumed – for instance, when they're being written out to disk 
in a wave \file::

    with open("output.wav", "wb") as f:
        audiogen.sampler.write_wav(f, beats)

Generators' at-consumption-time computation also allows creating 
**infinitely long output**, e.g. to stream to speakers rather than a file on
disk::

    audiogen.sampler.write_wav(sys.stdout, audiogen.tone(440))

Or just::

    audiogen.sampler.play(audiogen.tone(440))

You can also use standard generator tools, e.g. the itertools module, to 
handle audio data::

    beep_silence = itertools.chain(audiogen.beep(), audiogen.silence(0.5))
    infinite_beeps = itertools.cycle(beep_silence)
    
    audiogen.sampler.write_wav(sys.stdout, infinite_beeps)
    
Soundcard output
----------------

The easiest way to play directly to a soundcard output is to use the 
``audiogen.sampler.play`` function, which will play your samples using 
PyAudio::

    import audiogen_p3 as audiogen
    import itertools
    import sys

    audiogen.sampler.play(audiogen.beep(frequency=440, seconds=0.25))

    # or make an infinite generator alternating between beep and silence:
    
    audiogen.sampler.play(
        itertools.cycle(itertools.chain(audiogen.beep(), audiogen.silence(0.5)))
    )

Alternatively, you could write your wave data to ``stdout``, e.g. ``myaudio.py``::

    import audiogen_p3 as audiogen
    import itertools
    import sys
    
    audiogen.sampler.write_wav(
        sys.stdout,
        itertools.cycle(itertools.chain(audiogen.beep(), audiogen.silence(0.5)))
    )

Then pipe to a command line audio player like Sox_::

    python myaudio.py | play -t wav -

Installation
------------

Install with::

    $ python3 -m pip install audiogen_p3
    $ python3 -m pip install --allow-external PyAudio --allow-unverified PyAudio PyAudio

PyAudio is optional. If it's not installed, playing audio via the soundcard with
``audiogen_p3.sampler.play()`` will not be available, but generating Wave files – 
including for piping to an external player, like ``sox`` – will work just fine. 

Note that to install PyAudio on Mac OS X, you'll need to first install ``portaudio``::

    $ brew install portaudio

Contributing
------------

Get the source and report any bugs on Github:

    https://github.com/rguisewite/audiogen_p3

Original Code from Christopher H. Casebeer (casebeer):
    https://github.com/rguisewite/audiogen

Version history
---------------

- 0.1.2 - Add band pass and band stop IIR filters; custom beep lengths from @jhobbs
- 0.1.1 - Fix multiplexing bug causing increase in pitch when using mixer() to produce
  more than one output channel
- 0.1.0 - Breaking changes: new arguments to tone(), play() blocks by default

.. _Sox: http://sox.sourceforge.net/

