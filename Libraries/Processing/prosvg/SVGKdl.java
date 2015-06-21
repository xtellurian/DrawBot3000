package prosvg;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;

import processing.core.PApplet;
import processing.core.PGraphicsJava2D;

public class SVGKdl extends PGraphicsJava2D{

	private SVGGraphics svgGraphics;

	private PApplet parent;

	/**
	 * Constructor for the PGraphics2 object.
	 * This prototype only exists because of annoying
	 * java compilers, and should not be used.
	 */
	public SVGKdl(){
	}

	/**
	 * Constructor for the PGraphics object. Use this to ensure that
	 * the defaults get set properly. In a subclass, use this(w, h)
	 * as the first line of a subclass' constructor to properly set
	 * the internal fields and defaults.
	 *
	 * @param iwidth  viewport width
	 * @param iheight viewport height
	 */
	public SVGKdl(int iwidth, int iheight, PApplet parent){
		//super();
		setSize(iwidth, iheight);
		setParent(parent);
		this.parent = parent;
	}

	/**
	 * Called in repsonse to a resize event, handles setting the
	 * new width and height internally, as well as re-allocating
	 * the pixel buffer for the new size.
	 *
	 * Note that this will nuke any cameraMode() settings.
	 */
	public void resize(int iwidth, int iheight){ // ignore
		//System.out.println("resize " + iwidth + " " + iheight);

		width = iwidth;
		height = iheight;
		width1 = width - 1;
		height1 = height - 1;

		allocate();

		// clear the screen with the old background color
		//background(backgroundColor);
	}

	// broken out because of subclassing for opengl
	protected void allocate(){
		image = new BufferedImage(width, height, BufferedImage.TYPE_INT_ARGB);
		svgGraphics = new SVGGraphics((Graphics2D) image.getGraphics());

		// Create an instance of the SVG Generator
		g2 = svgGraphics;
	}

	/**
	 * Save this image to disk. This method will save to the "current"
	 * folder, which when running inside the PDE will be the location
	 * of the Processing application, not the sketch folder. To save
	 * inside the sketch folder, use the variable savePath from PApplet,
	 * or use saveFrame() instead.
	 */
	public void save(String filename){
		boolean success = false;

	    try{
			OutputStream os = null;
			loadPixels();
			if (filename.toLowerCase().endsWith(".tga")){
				os = new BufferedOutputStream(new FileOutputStream(filename), 32768);
				success = false;//saveTGA(os, pixels, width, height, format);
				os.flush();
				os.close();
			}else if (filename.toLowerCase().endsWith(".tif") || filename.toLowerCase().endsWith(".tiff")){
				os = new BufferedOutputStream(new FileOutputStream(filename), 32768);
				success = false;//saveTIFF(os, pixels, width, height);
				os.flush();
				os.close();
			}else{
				if (!filename.toLowerCase().endsWith(".svg")){
					// if no .svg extension, add it..
					filename += ".svg";
				}
				File file = new File(filename);

				//PrintWriter output = new PrintWriter(new FileOutputStream(file));
				Writer out = new OutputStreamWriter(new FileOutputStream(file), "UTF-8");
				svgGraphics.getSvgGraphics().stream(out, true);
				success = true;
			}

		}catch (IOException e){
			// System.err.println("Error while saving image.");
			e.printStackTrace();
			success = false;
		}
	    if (!success) {
	      throw new RuntimeException("Error while saving image.");
	    }
	}
}
