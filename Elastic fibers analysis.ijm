/* Antonino Bongiovanni/Meryem Tardivel
Plate-forme d'imagerie cellulaire BiCel Campus HU
1 place Verdun, 59045 Lille*/


Dialog.create("Decoupe ou Analyse ?");
Dialog.addChoice("Type:", newArray("DECOUPE", "ANALYSE"));
Dialog.show();
type = Dialog.getChoice();



//DECOUPE**********************************************************************************************************

if (type=="DECOUPE")
{

dir=getDirectory("Repertoire Images ?");
files=getFileList(dir);
File.makeDirectory(dir+"DECOUPE");



run("Colors...", "foreground=white background=white selection=white");
run("Set Measurements...", "area shape feret's redirect=None decimal=6");
run("Line Width...", "line=2");


for(num=0;num<files.length;num++)
{
roiManager("Show None");
if (roiManager("count")>0) 
{	
roiManager("Delete");
}
if (roiManager("count")>0) 
{	
roiManager("Delete");
}

open(dir+files[num]);
filename=File.name;
run("Clear Results");
run("Colors...", "foreground=white background=white selection=white");
run("Set Measurements...", "area shape feret's redirect=None decimal=6");
run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width=0.220 pixel_height=0.220 voxel_depth=1.0000000 global");
run("Duplicate...", "title=RGB-filename");
rename("RGB-filename");
selectWindow(filename);
close();
selectWindow("RGB-filename");
rename(filename);
run("Colors...", "foreground=white background=white selection=white");
k=1;
do
{
setTool("polygon");
waitForUser("Region : Derme (right clic to finish)");
run("Duplicate...", "title=decoupe");
run("Clear Outside");
run("Select All");
saveAs("tif", dir+"DECOUPE"+File.separator+filename+"-"+k);
close();
k=k+1;
stop2=0;
Dialog.create("Encore ?");
Dialog.addCheckbox("Yes", true);
Dialog.show();
stop = Dialog.getCheckbox();
 if (stop==true)
 {
 	stop2=1;
 }

}
while (stop2==1);
selectWindow(filename);
close();
}
}


//ANALYSE**********************************************************************************************************

if (type=="ANALYSE")
{
"\\Clear";	
dir2=getDirectory("Repertoire DECOUPE ?");
files2=getFileList(dir2);
File.makeDirectory(dir2+"ANALYSE");


Dialog.create("Detection couleur Auto ?");
Dialog.addChoice("Type:", newArray("MANUELLE", "AUTO"));
Dialog.show();
type2 = Dialog.getChoice();



name=newArray(100000);
area=newArray(100000);
surface_selectionne=newArray(10000000);
surface_fibre_moy=newArray(10000000);
surface_fibre_cumule=newArray(10000000);
ratio=newArray(10000000);
feretMin=newArray(10000000);
feretMax=newArray(10000000);
circ=newArray(10000000);
feretMin_cum=newArray(10000000);
feretMax_cum=newArray(10000000);
circ_cum=newArray(10000000);
feretMin_moy=newArray(10000000);
feretMax_moy=newArray(10000000);
circ_moy=newArray(10000000);

for(num2=0;num2<files2.length;num2++)
{
	
if (roiManager("count")>0) 
{	
roiManager("Delete");
}
if (roiManager("count")>0) 
{	
roiManager("Delete");
}
	
open(dir2+files2[num2]);
if (roiManager("count")>0) 
{	
roiManager("Delete");
}
if (roiManager("count")>0) 
{	
roiManager("Delete");
}
filename2=File.name;
print("****************************************************************");
print("name;"+filename2);
name[num2]=File.name;
run("Select All");
run("Colors...", "foreground=white background=white selection=white");
rename("Deconv");
run("Duplicate...", "title=RGB");
selectWindow("Deconv");
run("Duplicate...", "title=CONTOUR");
run("8-bit");
setThreshold(0, 217);
run("Convert to Mask");
run("Close-");
run("Fill Holes");
run("Analyze Particles...", "size=50000-Infinity add");
selectWindow("CONTOUR");
close();
selectWindow("Deconv");
roiManager("Select", 0);
run("Clear Outside");
selectWindow("RGB");
roiManager("Select", 0);
run("Measure");
surface_selectionne[num2]=getResult("Area",0);
run("Clear Results");
run("Clear Outside");

if (roiManager("count")>0) 
{	
roiManager("Delete");
}
if (roiManager("count")>0) 
{	
roiManager("Delete");
}
if (roiManager("count")>0) 
{	
roiManager("Delete");
}

selectWindow("Deconv");
run("Select All");

if (type2=="AUTO")
{
run("Colour Deconvolution", "vectors=[User values] [r1]=-0.57735026 [g1]=-0.57735026 [b1]=-0.57735026 [r2]=0.48804852 [g2]=0.55093145 [b2]=0.67696613 [r3]=0.48039162 [g3]=0.60823035 [b3]=0.6318859");
}

if (type2=="MANUELLE")
{
run("Colour Deconvolution", "vectors=[From ROI]");
}
selectWindow("Deconv-(Colour_1)");
close();
selectWindow("Deconv-(Colour_2)");
close();
selectWindow("Colour Deconvolution");
close();
selectWindow("Deconv-(Colour_3)");
setThreshold(0, 164);
run("Convert to Mask");
run("Clear Results");
run("Select All");
run("Analyze Particles...", "size=3-45 circularity=0.00-0.2 add");
selectWindow("Deconv-(Colour_3)");
close();
selectWindow("Deconv");
close();
roi=roiManager("count");
print("area;FeretMin;FeretMax;circularity");
for (i=0;i<roi;i++)
	{
		run("Clear Results");
		roiManager("Select", i);
		run("Measure");
		area[roi]=getResult("Area",0);
		feretMin[roi]=getResult("MinFeret",0);
		feretMax[roi]=getResult("Feret",0);
		circ[roi]=getResult("Circ.",0);
		print(area[roi]+";"+feretMin[roi]+";"+feretMax[roi]+";"+circ[roi]);
		surface_fibre_cumule[num2]=surface_fibre_cumule[num2]+getResult("Area",0);
		feretMin_cum[num2]=feretMin_cum[num2]+getResult("MinFeret",0);
		feretMax_cum[num2]=feretMax_cum[num2]+getResult("Feret",0);
		circ_cum[num2]=circ_cum[num2]+getResult("Circ.",0);
		run("Colors...", "foreground=red background=red selection=red");
		selectWindow("RGB");
		roiManager("Select", i);
		run("Draw");
		run("Clear Results");
	}

surface_fibre_moy[num2]=surface_fibre_cumule[num2]/roi;
feretMin_moy[num2]=feretMin_cum[num2]/roi;
feretMax_moy[num2]=feretMax_cum[num2]/roi;
circ_moy[num2]=circ_cum[num2]/roi;
ratio[num2]=surface_fibre_cumule[num2]/surface_selectionne[num2];

if (roiManager("count")>0) 
{	
roiManager("Delete");
}
if (roiManager("count")>0) 
{	
roiManager("Delete");
}
if (roiManager("count")>0) 
{	
roiManager("Delete");
}

selectWindow("RGB");
saveAs("jpeg", dir2+"ANALYSE"+File.separator+filename2+"-RGB");
close();
}

for(num2=0;num2<files2.length;num2++)
{
setResult("Label",num2,name[num2]);
setResult("Surface Selectionnee",num2,surface_selectionne[num2]);
setResult("Surface fibre cumulee",num2,surface_fibre_cumule[num2]);
setResult("Surface fibre moyenne",num2,surface_fibre_moy[num2]);
setResult("Ratio Fibre",num2,ratio[num2]);
setResult("FeretMin moyen",num2,feretMin_moy[num2]);
setResult("FeretMax moyen",num2,feretMax_moy[num2]);
}
	updateResults;

selectWindow("Results"); 
saveAs("Results",dir2+"ANALYSE"+File.separator+"Results per image.xls");
selectWindow("Log");
saveAs("txt",dir2+"ANALYSE"+File.separator+"Results par fibre.txt");
}	














