mixcut
======

This is a script, which allows you to split your mixtape (album, merged in one file) back into files. Written in pure Bash.


##Dependencies

* Bash
* ffmpeg
* mp3info

##Usage

 1. Rename your mixtape to `ARTIST-ALBUM\ NAME.mp3`, otherwise it won't work.
 2. Create your timeline file formatted like this:
 	    
 	     00:00,01:56,Track 1
 	     01:57,02:55,Track 2

 3. Save it with any name.
 4. Run: `mixtape.sh ARTIST-ALBUM\ NAME.mp3  your-timeline-file`
 5. ffmpeg does its magic.
 6. Profit. 
 	

 
