//apple help: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/WinPanel/Tasks/SizingPlacingWindows.html
//aplle refs: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSWindow_Class/index.html#//apple_ref/occ/instm/NSWindow/setTitle:

//round borderless,titleless, etc interface window: https://developer.apple.com/library/mac/samplecode/RoundTransparentWindow/Introduction/Intro.html

//borderless window
//http://www.cimgf.com/cocoa-code-snippets/nswindow-snippets/

//fullscrreen: window.setFrame(NSScreen.mainScreen()!.visibleFrame, display: true, animate: true)

//pin to front:  
[self.window makeKeyAndOrderFront:nil];
[self.window setLevel:NSStatusWindowLevel];


//custom window: in objc: http://www.cocoawithlove.com/2008/12/drawing-custom-window-on-mac-os-x.html


//docs: nswin swift osx: https://developer.apple.com/library/mac/documentation/Cocoa/Reference/ApplicationKit/Classes/NSWindow_Class/#//apple_ref/occ/instm/NSWindow/initWithContentRect:styleMask:backing:defer:


  
  