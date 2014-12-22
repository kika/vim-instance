# Create separate Vim instance for each Git/Mercurial/SVN project

This script, being used as a wrapper around Vim invocation, creates a separate Vim instance for separate Git/Hg or SVN project. New files from such project are opened in the same instance as separate tabs.
The servername script assigns to the instance is the same as the directory name with the .hg, .git or .svn subdirectory.
When combined with session management plugin such as [vim-session] [https://github.com/xolox/vim-session] it allows to create a truly standalone development environments for standalone projects when doing some serious multitasking.

## Currently tested only on Mac with MacVim

