# Node Version Controller

> Each of us probably work with multiple projects before, and in each project, there is a different node version compare to the other.
> Some project will be "14.x.x", other may be "16.x.x", etc.

The aim of this file is to create a automatic switch version whenever we `cd` into the projet's directory.

In order for it to work, you will need to either installed `n` or `nvm` version manager already.
And also, inside the project, there should be a file `.nvmrc`.

This `.nvmrc` will only contain the node version of that project.
