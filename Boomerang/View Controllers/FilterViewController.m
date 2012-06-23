//
//  FilterViewController.m
//  Boomerang
//
//  Created by Noman Naseem on 2/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()
@property (nonatomic, retain) GPUImagePicture *sourcePicture;
- (void)addTitleLabelOnScrollViewAtPage:(int)pageNo andText:(NSString *)text;
- (void)addSliderOnScrollViewAtPage:(int)pageNo min:(float)min max:(float)max normal:(float)normal;
- (void)addValueLabelOnScrollViewAtPage:(int)pageNo andText:(NSString *)text;
- (void)sliderValueChanged:(UISlider *)slider;
@end

@implementation FilterViewController
@synthesize sourcePicture;

#pragma mark - View lifecycle
- (void)viewDidLoad {
	CGSize size = scrollView.frame.size;
	scrollView.contentSize = CGSizeMake(size.width * 6, size.height);
	
    UIImage *image = [UIImage imageNamed:@"Icon@2x.png"];
    sourcePicture = [[GPUImagePicture alloc] initWithImage:image smoothlyScaleOutput:NO];
	
	int page = 1;
	[self addTitleLabelOnScrollViewAtPage:page andText:@"Saturation"];
	[self addSliderOnScrollViewAtPage:page min:0.0f max:2.0f normal:1.0f];
	[self addValueLabelOnScrollViewAtPage:page andText:@"1.00"];
	
	page = 2;
	[self addTitleLabelOnScrollViewAtPage:page andText:@"Exposure"];
	[self addSliderOnScrollViewAtPage:page min:-10.0f max:10.0f normal:0.0f];
	[self addValueLabelOnScrollViewAtPage:page andText:@"0.00"];
	
	page = 3;
	[self addTitleLabelOnScrollViewAtPage:page andText:@"Gamma"];
	[self addSliderOnScrollViewAtPage:page min:0.0f max:3.0f normal:1.0f];
	[self addValueLabelOnScrollViewAtPage:page andText:@"1.00"];
	
	page = 4;
	[self addTitleLabelOnScrollViewAtPage:page andText:@"Contrast"];
	[self addSliderOnScrollViewAtPage:page min:0.0f max:4.0f normal:1.0f];
	[self addValueLabelOnScrollViewAtPage:page andText:@"1.00"];
	
	page = 5;
	[self addTitleLabelOnScrollViewAtPage:page andText:@"Brightness"];
	[self addSliderOnScrollViewAtPage:page min:-1.0f max:1.0f normal:0.0f];
	[self addValueLabelOnScrollViewAtPage:page andText:@"0.00"];
	
	page = 6;
	[self addTitleLabelOnScrollViewAtPage:page andText:@"Sharpness"];
	[self addSliderOnScrollViewAtPage:page min:-4.0f max:4.0f normal:0.0f];
	[self addValueLabelOnScrollViewAtPage:page andText:@"0.00"];
	
	// Setup filters
	saturationFilter = [[GPUImageSaturationFilter alloc] init];
	exposureFilter = [[GPUImageExposureFilter alloc] init];
	gammaFilter = [[GPUImageGammaFilter alloc] init];
	contrastFilter = [[GPUImageContrastFilter alloc] init];
	brightnessFilter = [[GPUImageBrightnessFilter alloc] init];
	sharpenFilter = [[GPUImageSharpenFilter alloc] init];
	[sourcePicture addTarget:saturationFilter];
	[saturationFilter addTarget:exposureFilter];
	[exposureFilter addTarget:gammaFilter];
	[gammaFilter addTarget:contrastFilter];
	[contrastFilter addTarget:brightnessFilter];
	[brightnessFilter addTarget:sharpenFilter];
	
	// Set initial values
	[saturationFilter setSaturation:1.0f];
	[exposureFilter setExposure:0.0f];
	[gammaFilter setGamma:1.0f];
	[contrastFilter setContrast:1.0f];
	[brightnessFilter setBrightness:0.0f];
	[sharpenFilter setSharpness:0.0f];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[sourcePicture release];
	[saturationFilter release];
	[exposureFilter release];
	[gammaFilter release];
	[contrastFilter release];
	[brightnessFilter release];
	[imageView release];
	[scrollView release];
	[super dealloc];
}

- (void)viewDidUnload {
	[imageView release];
	imageView = nil;
	[scrollView release];
	scrollView = nil;
	[super viewDidUnload];
}

#pragma mark Touch delegate
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	[imageView setImage:[UIImage imageNamed:@"Icon@2x.png"]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self sliderValueChanged:nil];
}

#pragma mark Class methods
- (void)addTitleLabelOnScrollViewAtPage:(int)pageNo andText:(NSString *)text {
	float originX = (pageNo - 1) * scrollView.frame.size.width;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, 12, scrollView.frame.size.width, 24)];
	label.text = text;
	label.textAlignment = UITextAlignmentCenter;
	label.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0f];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	[scrollView addSubview:label];
	[label release];
}

- (void)addSliderOnScrollViewAtPage:(int)pageNo min:(float)min max:(float)max normal:(float)normal {
	float diffX = 5.0f;
	float originX = (pageNo - 1) * scrollView.frame.size.width;
    UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(originX+diffX, 50, scrollView.frame.size.width-(diffX*2), 44)];
    slider.minimumValue = min;
    slider.maximumValue = max;
    slider.value = normal;
    slider.continuous = YES;
	slider.tag = pageNo;
    [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [scrollView addSubview:slider];
	[slider release];
}

- (void)addValueLabelOnScrollViewAtPage:(int)pageNo andText:(NSString *)text {
	float originX = (pageNo - 1) * scrollView.frame.size.width;
	UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(originX, 100, scrollView.frame.size.width, 24)];
	label.text = text;
	label.textAlignment = UITextAlignmentCenter;
	label.tag = pageNo;
	label.font = [UIFont fontWithName:@"Helvetica" size:16.0f];
	label.backgroundColor = [UIColor clearColor];
	label.textColor = [UIColor whiteColor];
	[scrollView addSubview:label];
	[label release];
}

- (void)sliderValueChanged:(UISlider *)slider {
	// Update label value
	for (UILabel *label in [scrollView subviews])
		if ([label isKindOfClass:[UILabel class]] && label.tag == slider.tag && slider != nil)
			label.text = [NSString stringWithFormat:@"%.2f", slider.value];
	
	if (slider.tag == 1)
		[saturationFilter setSaturation:slider.value];
	else if (slider.tag == 2)
		[exposureFilter setExposure:slider.value];
	else if (slider.tag == 3)
		[gammaFilter setGamma:slider.value];
	else if (slider.tag == 4)
		[contrastFilter setContrast:slider.value];
	else if (slider.tag == 5)
		[brightnessFilter setBrightness:slider.value];
	else if (slider.tag == 6)
		[sharpenFilter setSharpness:slider.value];
	
	// Update image
    [sourcePicture processImage];
    [imageView setImage:[sharpenFilter imageFromCurrentlyProcessedOutput]];
}
@end
