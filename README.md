# What is this repo ❓

This repo and README is the starting point for new memebers!

This repo contains the Docker configuration for SeeGoals. It sets up both the production and development environments.

# How to run 🚀

1. Note: this project uses a tool called Docker. Docker can be installed on both linux and windows, but is way easier to work with on linux. If you dont have linux on you computer, it's recomended to work from the lab computer "fetdatorn", and then using the "remote explorer" plugin in vscode. Ask around for help with this setup.

2. Start with cloning this repo to the comuter you decided to work from. Click green button with the text code at this [website](https://github.com/LiU-SeeGoals/seegoals). Then make sure "SSH" is selected, and then copy the text. Note: you need to have ssh keys to set this up. If you don't have it follow this [guide](https://docs.github.com/en/authentication/connecting-to-github-with-ssh/adding-a-new-ssh-key-to-your-github-account).

3. Then clone the repo by writing `git clone` and copying the command from previous step. It should look similar to this:

```
git clone git@github.com:LiU-SeeGoals/docker.git
```

4. Then go inside the new folder (repo) called docker `(cd docker)`. To start all the containers, run if you are on linux (recomended):

```
./start.sh
```

Select the option 1 (start base configuration)

All the containers will then start running.

To see the website, navigate to the URL displayed in the terminal log. You should see a slight vibration in the robots, indicating that the containers have started as expected.

# Want to code for the AI or the website?

Run the same command as mentioned above, then select another option depending on where you want to develop. You should select the option so where you want to develop is the local one. For example, if you want to develop on "controller" then select the option "local controller". You will automaticly enter the development environment in this terminal (docker container). You can see a folder that is named controller. This is where you should make the changes. Note: make sure to switch to your own branch to develop on.

# Want to configure Docker?

The images are available in the Packages tab of the repo at ```https://github.com/LiU-SeeGoals```. A GitHub Action builds and updates an image with every change in the main branch, as shown in this video: ```https://www.youtube.com/watch?v=RgZyX-e6W9E&list=LL&index=2&t=308s```.

Some images are sourced from ```https://github.com/RoboCup-SSL```. More RoboCup-SSL images will be added later for different configurations.
