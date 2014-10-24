mixcut
======

This is a script, which allows you to split your mixtape (album, merged in one file) back into files. Written in Bash.


##Dependencies

* Bash
* ffmpeg
* mp3info

##Usage

 1. Create your timeline file formatted like this:
 	    
 	     00:00,01:56,Track 1
 	     01:57,02:55,Track 2

 2. Save it under any name.
 3. Run: `./mixcut -a Artist -m Album\ Name -i album-file.mp3 -t timeline-file`
 4. ffmpeg and mp3info do its magic.
 5. Profit. 
 	

##Credit

[Vlad Slepukhin](http://fau.im)

No license applied.
