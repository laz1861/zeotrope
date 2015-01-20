//This program should generate zeotropic surfaces on a sphere

//define geometric constants

rc = 50; //radius of the cylinder
rs = rc;//radius of the sphere

AR = 10; //aspect ratio of height of cylinder to radius
i = 1000; //total number of points to map on cylinder/sphere


//==========drawing==================
//cylinder(h = rc*AR, r= rc, center = true);
//cyl_points();
difference(){
        
    union(){
        sphere(r = rs, center = true, $fn = 100);
        sph_points();
    }
    
    translate([0,0,-1.5*rs])
    cube([3*rs,3*rs,3*rs], center = true);
}
//==========module definition===========
module cyl_points()
{
    //start by mapping out the cylindrical points
    //the cylinder is centered at the origin
    //the points are spaced every 137.5 degrees angularly
    //the points are evenly spaced down the length of the cylinder

    for (n = [0:i-1])
    {   //for each pass through the loop, create one point at the correct coordinatee
        theta = 137.5 * n; //calculate the angle for the given point
        z = AR*rc/i*n-AR*rc/2; //the height for the given point
        //echo(z);
        x = rc*cos(theta);
        y = rc *sin(theta);
        translate([x,y,z])
            cyl_pt();
        
    }
        
        
    
}


module cyl_pt()
{
    cube(size = rc/12, center = true);
    
}

module sph_pt()
{
    cube(size = rc/25, center = true);
}

module sph_points()
{
    //start by calculating cylinderical points
    //the cylinder is centered at the origin
    //the points are spaced every 137.5 degrees angularly
    //the points are spaced evenly down the cylinder, resulting in a spiral
    union(){
        for (n = [0:i-1])
        {
            r = rc; //cylinder radius
            theta = 137.5 * n; //angle for a given point
            zc = AR*rc/i*n - AR*rc/2; //the height for a given point
            
            //now we convert these to points mapped to a sphere
            rho = rs; //spherical radius
            //theta = theta; //redundant, but we use the same theta for both cases
            phi = acos(zc/sqrt(pow(rc,2)+pow(zc,2))); //phi angle calculated from cylinder points
            
            //convert these points to cartesian
            x = rho * cos(theta) * sin(phi); 
            y = rho * sin(theta) * sin(phi);
            z = rho * cos(phi);
            
            //calculate a scale factor
            sf = (rho-abs(z))/7;
            //echo(rho, theta, phi);
            //echo(x,y,z);
            //not draw the points
            
            translate([x,y,z])
            scale([sf,sf,sf])
            sph_pt();
            
        }
    }
   
}