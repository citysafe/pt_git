pt_git
========

The gem is intended to simplify developer's live when dealing with pivotal tracker (PT) and git.

Features
--------

* `pt ls`

Examples
--------

As a developer, I live in my black and cozy tmux session and I don't love to leave it unless it is absolutely necessary.
But I have to, in order to have a look at the PT stories which are assigned to me.
So I think it would be great to be armed with terminal commands which allow user (say, me) to list all PT stories assigned to me in the terminal. Something like this:

```
> pt ls

#123123 (*) User should be able to login
#123445 (bug) Logout is broken
...

```


The ls command can also have flags, which allow me to control the output.
Say, if I add `-v` flag, then the output contains story descriptions, --comments outputs all comments as well, and so on.
`pt ls #123123 --comments` outputs the detailed information about the story together with all comments.

One more thing which I often do is creating a git branch which contains PT story id in its name.
So `pt git-branch` could be useful here, creating a new git branch with a name consisting of PT id and story title, same as git checkpout -b 123123-user-should-be-able-to-login, but with less typing.

Requirements
------------

* a Pivotal Tracker project
* Pivotal Tracker api service (under Admin -> Service Hooks)

Install
-------

``gem install pt_git``

Once installed, pt_git needs two bits of info: your Pivotal Tracker API Token and your Pivotal Tracker project id:

``git config --global pivotal.api-token 123a456b``

The project id is best placed within your project's git config:

``git config pivotal.project-id 88888``

If you project's access is setup to use HTTPS:

``git config pivotal.use-ssl 1``
