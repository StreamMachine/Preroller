     ______   ______   ______  ______   ______   _        _        ______  ______  
    | |  | \ | |  | \ | |     | |  | \ / |  | \ | |      | |      | |     | |  | \ 
    | |__|_/ | |__| | | |---- | |__| | | |  | | | |   _  | |   _  | |---- | |__| | 
    |_|      |_|  \_\ |_|____ |_|  \_\ \_|__|_/ |_|__|_| |_|__|_| |_|____ |_|  \_\
	
# What

Preroller provides a unified platform for serving preroll audio to KPCC's live 
stream, podcasts and apps.

# Requirements

We use ffmpeg for audio processing.  It must be in the application's path, and 
must be compiled with lame and faac:

    ./configure --enable-libmp3lame --enable-libfaac --enable-nonfree
	
# Who

Project was started by Eric Richardson <erichardson@scpr.org> on April 18, 2012.