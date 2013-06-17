The `chef-tlc-workflow` makes our workflow for developing with Chef explict by adding a set of Rake tasks embodying the workflow. It's an extension of [chef-workflow](https://github.com/chef-workflow/chef-workflow) providing the additional workflow-encapsulating Rake tasks in the `tlc` namespace.

## Workflow Tasks

-------------------------

    *!!! CAUTION: the text below about workflow tasks is not accurate anymore !!!*

    Why? Because I believe its better to provide a Rakefile via Scaffolding mechanism. 
    This is more transparent and easier to adapt than providing prebaked Rake tasks 
    in a gem library.

    Right now we still have the Rake tasks mentioned below, but we treat them as internal
    Rake tasks that we invoke from the scaffolded Rakefiles. They don't show up when 
    running `rake -T` because they have now `desc`ription (but `rake -T -A` still shows them).

    Even if we keep them, the namespaces are likely to change so they are structured 
    per-project-type (e.g. library cookbook project, application cookbook project or
    infrastructure project), e.g:

    * lib
     * create
     * release
     * resolve_deps
     * validate (Berksfile in .gitignore)
     * test (u.a. => test:converge, ggf. chef-workflow testlib?)
    * app
     * create
     * release
     * resolve_deps
     * validate (=> u.a. deps:check, Berksfile nicht in .gitignore)
     * test (was auch immer das heisst)
    * infra
     * create
     * resolve_deps (= app cookbooks)
     * validate
     * test (was auch immer das heisst)

    Furthermore, the scaffolding tasks should be rather implemented as a knife plugin, 
    because when we use them there is no Rakefile yet (chicken-egg problem).

-------------------------

Once you installed the gem or added it to your `Gemfile` as shown above, simply add the following to your project's `Rakefile` to have all TLC workflow tasks available:

    # first, chef-workflow-tasklib must be required
    require 'chef-workflow-tasklib'

    # then you can include _all_ tlc tasks like this
    chef_workflow_task 'tlc'

Or, if you need only specific workflow tasks, they can be included separately:

    ...
    # include dependency management related tasks
    chef_workflow_task 'tlc/deps'

You should then have the TLC workflow tasks available: 

    $ bundle exec rake -T
    rake tlc:deps:check     # check if dependencies in metadata.rb and Cheffi...
    rake tlc:deps:resolve   # resolve dependencies using librarian
    rake tlc:test:converge  # destroy the Vagrant VM, resolve dependencies an...

### Available Workflow Tasks

Currently available are these tasks.

#### Cookbook Dependency Management

The `deps` namespace embodies the workflow concerning cookbook dependency management
  
 * `tlc:deps:resolve` - resolve dependencies using [librarian](https://github.com/applicationsonline/librarian)
 * `tlc:deps:check` - check if dependencies in `metadata.rb` and `Berksfile` are consistent

#### Cookbook Testing

The `test` namespace represents the workflow for testing of individual cookbook projects

 * `tlc:test:converge` - destroy the default Vagrant VM first, then resolve dependencies and converge the default Vagrant VM
