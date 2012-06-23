//
//  FilterViewController.h
//  Boomerang
//
//  Created by Noman Naseem on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GPUImage.h"

@interface FilterViewController : UIViewController {
	GPUImageSaturationFilter *saturationFilter;
	GPUImageExposureFilter *exposureFilter;
	GPUImageGammaFilter *gammaFilter;
	GPUImageContrastFilter *contrastFilter;
	GPUImageBrightnessFilter *brightnessFilter;
	GPUImageSharpenFilter *sharpenFilter;
	
	IBOutlet UIImageView *imageView;
	IBOutlet UIScrollView *scrollView;
}

@end
