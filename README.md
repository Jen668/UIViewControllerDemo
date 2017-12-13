# UIViewController详解


## 概述

视图控制器管理着构成应用程序用户界面中的一部分视图，其负责加载和处理这些视图，管理与这些视图的交互，并协调视图对其展示的数据内容的变更作出响应。视图控制器还能与其他视图控制器对象协调工作，帮助管理应用程序的整体界面。

视图控制器的主要职责包括以下内容：
- 更新视图的内容来响应底层数据的变化。
- 响应用户与视图的交互。
- 调整视图大小并管理整个界面的布局。

## 视图控制器的作用

视图控制器是应用程序内部结构的基础。每个应用程序至少含有一个视图控制器，大多数应用程序都含有多个视图视图控制器。每个视图控制器管理着应用程序的用户界面，以及该界面和底层数据之间的交互。视图控制器也便于在不同用户界面之间的转换。

`UIViewController`类定义了一些方法和属性来管理视图、处理事件、从一个视图控制器切换到另一个视图控制器和协调应用程序的其他部分，可以通过继承`UIViewController`（或其子类之一）来添加实现应用程序行为所需的自定义代码。

有两种类型的视图控制器：
- 内容视图控制器，其管理着应用程序内容的一部分。
- 容器视图控制器，其收集来自于其他视图控制器的信息并以便于导航的方式呈现或者以不同方式呈现这些视图控制器的内容。

### 视图管理

视图控制器最重要的作用是管理视图的层次结构。每个视图控制器都含有一个包含所有视图控制器内容的根视图，可以添加需要显示内容的视图到该根视图中。下图显示了视图控制器和视图之间的内置关系，视图控制器总是具有对其根视图的强引用，并且每个视图都具有对其子视图的强引用。

![图2-1](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_ControllerHierarchy_fig_1-1_2x.png)

内容视图控制器自己管理其包含的所有视图，容器视图控制器管理其所包含的所有视图以及来自其一个或多个子视图控制器的**根视图**。容器视图控制器并不管理其子视图控制器的内容，只管理其子视图控制器的根视图。下图说明了`UISplitViewController`与其子视图控制器之间的关系。`UISplitViewController`管理其子视图的整体大小和位置，但子视图控制器管理这些视图的实际内容。

![图2-2](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_ContainerViewController_fig_1-2_2x.png)

### 数据封送

视图控制器充当其管理的视图与应用程序数据之间的媒介。子类化`UIViewController`的时候，可以添加任何需要在子类中管理的数据变量。添加自定义变量会创建一个如下图所示的关系，其中视图控制器具有对数据的引用以及用于呈现该数据的视图。

![图2-3](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_CustomSubclasses_fig_1-3_2x.png)

应该始终在视图控制器和数据对象中保持清晰的职责分离。大多数确保数据结构完整性的逻辑应属于数据对象本身。视图控制器可以验证来自视图的输入，然后以数据对象需要的格式打包输入，但是应该最小化视图控制器在管理实际数据中的角色。

`UIDocument`对象是一种独立于视图控制器管理数据的方式。文档对象是一个知道如何读写数据到持久存储的控制器对象。子类化`UIDocument`时，可以添加任何需要的逻辑和方法来提取数据，并将其传递给视图控制器或者应用程序的某部分。视图控制器可以存储其接收到的任何数据的副本，以便更新视图，但文档仍然拥有真实的数据。

### 用户交互

视图控制器是响应者对象，能够处理响应者链中传递的事件，但视图控制器很少直接处理触摸事件。相反，视图通常会处理自己的触摸事件，并将结果报告给其关联的委托或目标对象（通常是视图控制器）的方法。因此，视图控制器中的大多数事件都是使用委托方法或操作方法处理的。

### 资源管理

视图控制器对其视图和它创建的任何对象承担全部责任。`UIViewController`类自动处理视图管理的大多数方面，例如，UIKit自动释放不再需要的任何视图相关的资源。子类化`UIViewController`时，需要自己负责管理创建的任何对象。

当可用空闲内存不足时，UIKit会要求应用程序释放不再需要的资源。其中一种方式是通过调用视图控制器的`didReceiveMemoryWarning`方法来删除对不再需要的对象的引用或者稍后重新创建。例如，在该方法中删除缓存的数据。发生内存不足的情况时，释放尽可能多的内存非常重要。消耗太多内存的应用程序可能会被系统彻底终止以恢复内存。

### 适应性

视图控制器负责呈现其视图，并使该呈现适应底层环境。每个iOS应用程序都应该能够在iPad上运行，并且可以在几种不同大小的iPhone上运行。不是为每个设备提供不同的视图控制器和视图层，而是使用单个视图控制器来更简单地调整其视图以适应不断变化的空间需求。

在iOS中，视图控制器需要处理粗粒度的变化和细粒度的变化。当视图控制器的特性改变时，会发生粗粒度的变化。特征是描述整体环境的属性，例如显示比例。其中两个最重要的特性是视图控制器的水平和垂直尺寸类别，是它们表示视图控制器在给定维度中有多少空间。可以使用size class changes来改变布局视图的方式，如下图所示。当horizontal size class是规则的，视图控制器利用额外的水平空间来排列其内容。当horizontal size class是紧凑的，视图控制器垂直排列其内容。

![图2-4](https://developer.apple.com/library/content/featuredarticles/ViewControllerPGforiPhoneOS/Art/VCPG_SizeClassChanges_fig_1-4_2x.png)

根据给定的size class，可以随时进行更细粒度的尺寸更改。当用户将iPhone从纵向旋转到横向时，size class可能不会改变，但屏幕尺寸通常会改变。在使用自动布局时，UIKt会自动调整视图的大小和位置以匹配新维度。视图控制器可以根据需要进行其他调整。
