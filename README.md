distributed-sound-visualisation
===============================

   ===Requirements===
   
   Processing 2.0 Beta 8 (untested on earlier)
   Microphone
   Tape measure
   Duel Core 2.0Ghz or higher
   2GB RAM
   Dedicated Graphics
   
   
   ===Description====
   
   A cross screen, cross window directional audio visualisation inspired by various artists.
      

   ===Instructions===

   1) Open and run /Processing sketches/SynServer/SynServer.pde
   
   2) Open /Processing sketches/SynScreens/SynScreens.pde
     a. Set 'monitorsize' to the size of the monitor in inches
     b. Set 'offsetX' and 'offsetY' to the screen's offset to the first screen in metres
	 c. Set 'micOffsetX' and 'micOffsetY' to the microphone's offset relative to the screen in metres
	 d. Set 'serverIP' and 'serverPort' to the IP address and the port of the server
	 e. Run
	 
	 
   ===Notes==========
   
   If a client is started without a server it will try every 5 seconds to connect.
   
   Current implementation has occasional memory leaks, the impact of these can be reduced by raising 
   the memory allowance for processing and using a 64bit version of processing.
   
   If more than one client is running, the server will attempt to match sounds based on pitch and work 
   out the distance between the two detection points based on the volume recieved at each.
   
   The server sketch (SynServer.pde) shows a simplified view of the outgoing events, Red events have been generated 
   by the server based on two pitch matched events, white events are original.
   
   
   ===Videos=========
   
   Visualisation concepts - http://www.youtube.com/watch?v=a3veQnBNxqQ
   First synchronised effects test - http://www.youtube.com/watch?v=fLmConayIic
   Window location based mapping - http://www.youtube.com/watch?v=VIGsnx3ogQU
   Microphone offsets - http://www.youtube.com/watch?v=LeGIThdvXLM
   Directional sound - http://www.youtube.com/watch?v=KsDtbycRP84
   
   ===Change Log=====
   
   v1.1 added support for processing 2.0b8
   v1.0 release
   