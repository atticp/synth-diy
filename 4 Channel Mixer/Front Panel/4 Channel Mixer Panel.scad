
panelThickness = 2;
panelHp=10;
holeCount=4;
holeWidth = 5.08; //If you want wider holes for easier mounting. Otherwise set to any number lower than mountHoleDiameter. Can be passed in as parameter to eurorackPanel()

walls=true;
two_walls=true;
wall_size=5;

panelHoles=true;

panelText=true;
textDepth=0.7;
titleText="MIXER";

threeUHeight = 133.35; //overall 3u height
panelOuterHeight =128.5;
panelInnerHeight = 110; //rail clearance = ~11.675mm, top and bottom
railHeight = (threeUHeight-panelOuterHeight)/2;
mountSurfaceHeight = (panelOuterHeight-panelInnerHeight-railHeight*2)/2;

hp=5.08;
mountHoleDiameter = 3.2;
mountHoleRad =mountHoleDiameter/2;
hwCubeWidth = holeWidth-mountHoleDiameter;

offsetToMountHoleCenterY=mountSurfaceHeight/2;
offsetToMountHoleCenterX=hp;//1hp margin on each side

echo(offsetToMountHoleCenterY);
echo(offsetToMountHoleCenterX);

module eurorackPanel(panelHp,  mountHoles=2, hw = holeWidth, ignoreMountHoles=false)
{
    //mountHoles ought to be even. Odd values are -=1
    difference()
    {
        cube([hp*panelHp,panelOuterHeight,panelThickness]);
        
        if(!ignoreMountHoles)
        {
            eurorackMountHoles(panelHp, mountHoles, holeWidth);
        }
        
        if (panelText){
            panelText(titleText,12);
        }
        
        if (panelHoles){
                        
            panelHole(-18, 25.0, 3);
            panelHole(-18, 45.3, 3); 
            panelHole(-18, 65.6, 3);     
            panelHole(-18, 85.9, 3);
            
            panelHole(0, 25.0, 4);
            panelHole(0, 45.3, 4); 
            panelHole(0, 65.6, 4);     
            panelHole(0, 85.9, 4);
            
            panelHole(16, 25.0, 3);
            panelHole(16, 45.3, 3); 
            panelHole(16, 65.6, 3);     
            panelHole(16, 85.9, 3);
        }   
    }
}

module eurorackMountHoles(php, holes, hw)
{
    holes = holes-holes%2;//mountHoles ought to be even for the sake of code complexity. Odd values are -=1
    eurorackMountHolesTopRow(php, hw, holes/2);
    eurorackMountHolesBottomRow(php, hw, holes/2);
}

module eurorackMountHolesTopRow(php, hw, holes)
{
    
    //topleft
    translate([offsetToMountHoleCenterX,panelOuterHeight-offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    if(holes>1)
    {
        translate([(hp*php)-hwCubeWidth-hp,panelOuterHeight-offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    }
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,panelOuterHeight-offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHolesBottomRow(php, hw, holes)
{
    
    //bottomRight
    translate([(hp*php)-hwCubeWidth-hp,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    if(holes>1)
    {
        translate([offsetToMountHoleCenterX,offsetToMountHoleCenterY,0])
    {
        eurorackMountHole(hw);
    }
    }
    if(holes>2)
    {
        holeDivs = php*hp/(holes-1);
        for (i =[1:holes-2])
        {
            translate([holeDivs*i,offsetToMountHoleCenterY,0]){
                eurorackMountHole(hw);
            }
        }
    }
}

module eurorackMountHole(hw)
{
    
    mountHoleDepth = panelThickness+2; //because diffs need to be larger than the object they are being diffed from for ideal BSP operations
    
    if(hwCubeWidth<0)
    {
        hwCubeWidth=0;
    }
    translate([0,0,-1]){
    union()
    {
        cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
        translate([0,-mountHoleRad,0]){
        cube([hwCubeWidth, mountHoleDiameter, mountHoleDepth]);
        }
        translate([hwCubeWidth,0,0]){
            cylinder(r=mountHoleRad, h=mountHoleDepth, $fn=20);
            }
    }
}
}

module panelHole(hx,hy,hr=4)
{
    translate([hx+((hp*panelHp)/2),hy,-1]){
        holeDepth = panelThickness+2;
        cylinder(r=hr, h=holeDepth, $fn=20);
        }
}

module panelText(textValue,ty){
    translate([(hp*panelHp)/2,ty,0]){
        mirror([0,1,0]){
        linear_extrude(textDepth)
            text(textValue, size=4, font="Century Gothic:style=Bold", halign="center", valign="center"); 
            
        } 
    } 
}

eurorackPanel(panelHp, holeCount,holeWidth);
if (walls) {
    size = [2,panelOuterHeight-20,wall_size];

    translate([0,10,1]){
        cube(size);
    }
    
    if (two_walls) {
        translate([hp*panelHp-2,10,1]){
            cube(size);
        }
    }
}
