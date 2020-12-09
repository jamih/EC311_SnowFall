# EC311_BrickBreaker
EC311 Final Project

Our project is called "Snowfall". 
Our team members are:
Luca Guidi 
Jami Huang (U38052606)
Nicole Kwon
Bryan Jaimes

Link to our Project Demo Video: https://www.youtube.com/watch?v=ycBuij04aC4

The GitHub Repository is structured in the following way:

Sources - contains all project source files
Testbench Files - contains all project testbench files
Constraints - contains project constraints file for Nexys 4 Artix-7

The PS2Receiver.v and debouncer.v files were taken from:
https://github.com/Digilent/Nexys4DDR.git 



Overview of the Project: For our final project, we decided to create a winter-themed game utilizing the VGA display, speaker, keyboard, and FPGA. On the VGA display, the player is first presented with the start screen, followed by the gameplay, and finally the end screen. While the game is active, the speaker plays “Jingle Bells.” The objective of the game is to collect as much “snow” (white blocks) as possible with a paddle in a certain amount of allotted time (90 seconds). To officially start the game, the player should press the enter key. The player controls the paddle on the bottom of the screen with the left and right arrow keys (left and right respectively) and the space bar (stop) on the keyboard. After collecting 10 blocks of snow, the difficulty of the game increases. Snow blocks fall twice as fast, and there are “bombs” (red blocks) that the user must avoid. Points are earned for every snow block the user collects, and one point is deducted for every bomb they fail to avoid. These points are shown on the 7-segment display, and once the timer is up, the game is over. To restart the game, the player should press the backspace key. For the background music, the song “Jingle Bells” plays on the FPGA speaker output. A speaker or headphones needs to be connected to the jack on the FPGA to properly hear this. 

How to run our project: Download our zipped folder which contains all Verilog source files and the constraints file from Github. Open the Xilinx project file, generate bitstream, and program device. The FPGA should be connected to a monitor via VGA, and the sound can be played through a speaker.  

Overview of the code structure (what code does what): Our Verilog source files are stored in the “Sources” folder on Github. This includes code for…
User input of the keyboard (debouncer.v, which ensures that the keys will debounce and send a single signal upon contact, and PS2Receiver.v, which sets up the overall keyboard interface)
Output of the score on the 7 segment-display (bin_to_bcd.v, which converts binary to BCD, and score_display, which sets up the cathode, anode, and refresh signals to output the player’s current score)
Music output of “Jingle Bells” (music_ROM.v, which takes in an address and converts notes as frequencies, divideby12.v, which takes in these frequencies to get the octave and note, music.v, which sets up the song, and top.v, which sends the song to play on the speaker) 
VGA output of the gameplay (vga640x480.v, which sets up the VGA graphics, lfsr.v, which allows for the pseudo-randomization of the speed and generation of falling blocks, and brick_display.v, which initializes/instantiates the VGA and different components of the game [i.e. hard-coded text of the start and end screen, as well as the game of two difficulties, the timer of a 90-second countdown, the paddle that the user controls, and the blocks that fall from the top to the bottom of the screen]) 
