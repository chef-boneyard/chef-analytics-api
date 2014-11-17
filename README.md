Chef analytics Client
==============

ChefAnalytics is a Ruby client for interacting with a Chef analytics Server.


Quick start
-----------
Install via Rubygems:

    $ gem install chef-analytics

or add it to your Gemfile if you are using Bundler:

```ruby
gem 'chef-analytics', '~> 0.1'
```

In your library or project, you will likely want to include the `ChefAnalytics` namespace:

```ruby
include ChefAnalytics
```

Development
-----------
1. Clone the project on GitHub
2. Create a feature branch
3. Submit a Pull Request

Important Notes:

- **All new features must include test coverage.** At a bare minimum, Unit tests are required. It is preferred if you include acceptance tests as well.
- **The tests must be be idempotent.** The HTTP calls made during a test should be able to be run over and over.
- **Tests are order independent.** The default RSpec configuration randomizes the test order, so this should not be a problem.


License & Authors
-----------------
- Author: James Casey <james@getchef.com>

```text
Copyright 2014, Chef Software

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
```
