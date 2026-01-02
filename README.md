
## Setup & Run
- Download Godot 4.5
- Download the repo files
- Open the project in Godot
- Run the project (press (F5)) or hit the Play button in the top right of the editor
- Make sure the input mode in the top left of the game is (Input)
![Input image](readme_screenshots/readme_input_screenshot.png "Input")

## Controls
### Camera:
- **W**: Forward
- **S**: Backward
- **A**: Left
- **D**: Right
- **Q** or **Space**: Up
- **E** or **Shift**: Down

Roll the **scroll wheel** to increase and decrease movement speed.

Press **shift** to move faster, and hold **alt** to move slower.

Hold down the **right mouse button** to rotate the camera.
There's a slider in the editor to control mouse sensitivity.

## General features
# Menu
![Input image](readme_screenshots/board_menu_screenshot.png "Input")
On the left side is the board_menu. Here there are different tabs for different features.
- **AOEs**: Sets the type of Area of Effects for **AttackArea**. (Circle, Square, Cone)
- **Create**: Fill out one of the tabs and then it creates a spawners for the **Add** or **Map** tab.
- **Info**: Provides info on the object on the board you selected.
- **Edit**: Allows you to edit data on the object you are currently selecting.
- **Add**: Adds a created object to the board.
- **Map**: Changes the map on the board.

# Toolbar
![Input image](readme_screenshots/toolbar.png "Input")
On the bottom is the toolbar. Here the different states determine what happens when you click on the board. 
- **AttackArea**: Draw area of effects in a range from a point where you click (then hold) and then a point where you drag to.
- **Measure**: Draws a straight line between 2 points. Where you initially click, and then where you drag your mouse to.
- **Select**: Allows you to move objects on the board by clicking and dragging their bases(the green rectangle beneath figures, which also are inside objects just move your camera inside the 3D models to see them.)
- **Info**: Switches to the **Info** tab of the creature that was clicked on.



## DISCLAIMERS
3D models are created in different ways, and the origins/pivot points of those models may not actually be where the models are.
If you try to Add a model in and you see the base appear, but not the model, then the 3D model is likely a hundred or so meters away in the void.
Go to (Edit) and change the (Model Position) until you see the model. The y position is likely the value you'd want to change first.
