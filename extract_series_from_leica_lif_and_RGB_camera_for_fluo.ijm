/* November 2021
 * Bertand Vernay
 * vernayb@igbmc.fr
 *  
 *  Problem: 4 channels fluorescence acquisition on the mic4 with the colour camera in colour mode "composite". ImageJ opens 12 channels (R, G and B for each fluo channel)
 *  
 *  1- Open .lif serie,
 *  2a- extract channels 3,5,9,12 corresponding to the Blue for DAPI, Green for FITC, and Red for both TxRd and CY5 in this sequence
 *  2b- extract 3,5,9 corresponding to the Blue for DAPI, Green for FITC, and Red for TxRd in this sequence
 *  3- save as *.*Tiff
 *  
 *  
*/ 


// INITIALISE MACRO
print("\\Clear");
               
run("Bio-Formats Macro Extensions");	//enable macro functions for Bio-formats Plugin
print("select folder with your Data")
dir1 = getDirectory("Choose a Directory");
print("Select the Save Folder")
dir2 = getDirectory("Choose a Directory");
list = getFileList(dir1);
setBatchMode(true);
// PROCESS LIF FILES
for (i = 0; i < list.length; i++) {
	path=dir1+list[i];
	Ext.setId(path);
	Ext.getCurrentFile(fileToProcess);
	Ext.getSeriesCount(seriesCount); // this gets the number of series
	print("Processing the file = " + fileToProcess);
	// see http://imagej.1557.x6.nabble.com/multiple-series-with-bioformats-importer-td5003491.html
	for (j=0; j<seriesCount; j++) {
        Ext.setSeries(j);
        Ext.getSeriesName(seriesName);
        if (endsWith(seriesName, "Merged")){
			run("Bio-Formats Importer", "open=&path color_mode=Composite view=Hyperstack stack_order=XYCZT series_"+j+1); 
			fileNameWithoutExtension = File.nameWithoutExtension;
			setBatchMode("show");
			Stack.getDimensions(width, height, channels, slices, frames);
			print(channels);
			// 4 channels DAPI, FITC, TxRd and Cy5
			if (channels == 12){
				run("Make Substack...", "channels=3,5,9,12");
				saveAs("tiff", dir2+fileNameWithoutExtension+"_"+seriesName+".tif");
				run("Close All");
			}
			// 3 channels DAPI, FITC and TxRd 
			if (channels == 9){
				run("Make Substack...", "channels=3,5,9");
				saveAs("tiff", dir2+fileNameWithoutExtension+"_"+seriesName+".tif");
				run("Close All");
			}
        }
	}
}

print("************* DONE *************");