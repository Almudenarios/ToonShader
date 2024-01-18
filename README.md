# ToonShader

In 3D computer graphics, the calculations of surface shading are informed by the angle formed by the surface normal and the light direction.

Usually by multiplying the colour times the value of the cosine on that point. The cosine is useful because it takes a value of 1 where light directly hits the surface and 0 where the light is perpendicular. It also takes a negative value on the faces opposite the light, but we can clamp the values between 1 and 0 to get rid of that issue.

This usually makes for smooth shading, as the continuous change in the cosine creates a gradient. 

To create the desired effect (cel shading) we must quantize colour. This means approximating a range of colours to a particular tone, turning the gradient into a limited number of intermediate colours.  

This shader also enlarges the model along its normals in order to create an outline. This presents a bit of a disadvantage when it comes to low-poly flat-shaded models (it works well in smooth shaded low-poly) as the change in normals makes the outline faces grow apart, this is barely perceptible at a distance. 
