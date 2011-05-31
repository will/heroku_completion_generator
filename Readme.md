# _heroku tab completion generator
It makes the contents of _heroku completion file for zsh

It mostly works now, but it's still a work in progress
# installing
  Do you use oh-my-zsh? When this completion is finished, I'll try and get this as a proper plugin in there. In the meantime make a `plugins/heroku` directory in `custom`.
  
  Add `heroku` to your plugins list in `.zshrc`, and do this
  
    ruby completion_generator.rb > ~/.oh-my-zsh/custom/plugins/heroku/_heroku

  You'll also need a version of oh-my-zsh with [this pull request](https://github.com/robbyrussell/oh-my-zsh/pull/372) merged in, or make [this change](https://github.com/will/oh-my-zsh/commit/1ec4a83bf1779379f0f353888978e3c8f696ae53) to your `oh-my-zsh.sh` file yourself
  
  If you don't use oh-my-zsh, then add this in a directory that gets autoloaded somewhere
  
## requirements
* heroku gem >= v2.0
* zsh 4.3.11 - it sorta works with earlier versions, but you cant complete after the : in some of the commands

### mit license
