"Algo SDK Sample" is a sample project to demonstrate how to manipulate data from MindWare Mobile Headset (while running on iOS device) or canned data (while running on simulator) and pass to EEG Algo SDK for EEG algorithm analysis. This document explains the use of "AlgoSdk.framework".

Running on iOS device
=====================
1. Connecting NeuroSky MindWave Mobile Headset with iOS device
2. On the iOS app development machine (e.g. macbook), double click the Algo SDK Sample Xcode project (“Algo SDK Sample.xcodeproj”) to launch the project with Xcode
3. Select the iOS device (recommended to use iPad) connecting to the working headset as the target device
4. Update the code signing options in the project target settings
5. Select Product –> Run to build and install the “Algo SDK Sample” app
6. In the app,
	6.1. select algorithm(s) from top left corner and tap “Set Algos” to initialise EEG Algo SDK (by invoking "setAlgorithmTypes:" method)
	6.2. tap "Start“ to start process any incoming headset data (by invoking "startProcess:" method)
	6.3. tap "Pause" to pause EEG Algo SDK (by invoking "pauseProcess:" method)
	6.4. tap "Stop" to stop EEG Algo SDK (by invoking "stopProcess:" method)
	6.5. slide the slide bar to adjust the algorithm output interval (note: output interval of attention and meditation are fixed with 1 second), and then press “Interval” to set the output interval

Running on simulator
====================
1. On the iOS app development machine (e.g. MacBook), double click the Algo SDK Sample Xcode project (“Algo SDK Sample.xcodeproj”) to launch the project with Xcode
2. Update the code signing options in the project target settings
3. Select iOS simulator (recommended to use iPad)
4. Product –> Run to build and install the “Algo SDK Sample” app
5. In the app,
	5.1. select algorithm(s) from top left corner and tap “Set Algos” to initialise EEG Algo SDK (by invoking "setAlgorithmTypes:" method)
	5.2. tap "Start“ to start process canned data (by invoking "startProcess:" method)
	5.3. tap "Canned Data" to start feeding data to the EEG Algo SDK (by invoking "dataStream:" method) from "canned_data.c" and Algorithm Index output will be compared with the canned output in "canned_output.c"
	5.4. tap "Pause" to pause EEG Algo SDK (by invoking "pauseProcess:" method)
	5.5. tap "Stop" to stop EEG Algo SDK (by invoking "stopProcess:" method)
	5.6. slide the slide bar to adjust the algorithm output interval (note: output interval of attention and meditation are fixed with 1 second), and then press “Interval” to set the output interval
