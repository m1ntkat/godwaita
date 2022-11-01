# Base theme setup

Follow these steps to apply the Godwaita theme to your project.

First, [download](https://gitlab.com/zehkira/godwaita/-/archive/master/godwaita-master.zip) this repository and extract the contents. Copy the internal `godwaita/` directory to your project's top directory.

![Godot project directory](https://gitlab.com/zehkira/godwaita/-/raw/master/assets/docs/1.png)

Set `res://godwaita/theme.tres` as the theme for your top `Control` node.

![Control node theme setting](https://gitlab.com/zehkira/godwaita/-/raw/master/assets/docs/2.png)

|Note|
|-|
|You could set your project's theme instead. However, you will still need a node with the theme set for the following steps.|

# Adaptive colors setup

Godwaita can automatically adapt to the user's theme colors.

After completing the base theme setup, attach the `res://godwaita/gtk-colors.gd` script to your top `Control` node.

![Attaching a script](https://gitlab.com/zehkira/godwaita/-/raw/master/assets/docs/3.png)

# Interface design considerations

There are a few things to consider when transitioning your project to Godwaita or starting a new one.

### Sizes, padding, margins

Take this example UI:

![Paint app example](https://gitlab.com/zehkira/godwaita/-/raw/master/assets/docs/4.png)

After switching to Godwaita, it adapted to my system theme like so:

![Paint app, converted](https://gitlab.com/zehkira/godwaita/-/raw/master/assets/docs/5.png)

Other than the changes in padding, one thing of note is what happened to the color selection buttons in the top right corner. The method used to make them square was a rather awkward hack that stopped working immediately after some size value changes. You will likely need to address some size-related issues in your project, as Godwaita takes up a lot more space than the default theme.

### Colors and contrast

You must always remember that pretty much any element of your application's interface can become pretty much any color depending on the user's theme. For example, using white icons will result in them not being visible for light theme users.

![White icons, light background](https://gitlab.com/zehkira/godwaita/-/raw/master/assets/docs/6.png)

The only solutions to this available at the moment are:
* Give all your icons a subtle contrasting outline or a shadow
* Don't use icons
* Don't use the automatic recoloring script

|Warning|
|-|
|You should also avoid using custom font colors or changing the colors of any UI elements.|
