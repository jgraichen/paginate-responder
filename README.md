# Paginate::Responder

[![Gem](https://img.shields.io/gem/v/paginate-responder?logo=rubygems)](https://rubygems.org/gems/paginate-responder)
[![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/jgraichen/paginate-responder/test.yml?logo=github)](https://github.com/jgraichen/paginate-responder/actions/workflows/test.yml)

A Rails pagination responder with link header support.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'paginate-responder'
```

You will also need a pagination gem. `PaginateResponder` comes with adapters for

- [`will_paginate`](https://github.com/mislav/will_paginate),
- [`kaminari`](https://github.com/amatsuda/kaminari), and
- [`pagy`](https://github.com/ddnexus/pagy).

It is recommended to use only one pagination gem at once.

## Usage

Add `Responders::PaginateResponder` to your responder chain:

```ruby
class AppResponder < Responder
  include Responders::PaginateResponder
end

class MyController < ApplicationController
  self.responder = AppResponder
end
```

Or use it with [`plataformatec/responders`](https://github.com/plataformatec/responders):

```ruby
class MyController < ApplicationController
  responders Responders::PaginateResponder
end
```

`PaginateResponder` will add the following link headers to
non HTML responses:

- `first` First page's URL.
- `last` Last page's URL.
- `next` Next page's URL.
- `prev` Previous page's URL.

`next` and `prev` page links will not be added if current page is `first` or `last` page.

Additionally, a `X-Total-Pages` header will be added with the total number of pages if available and a `X-Total-Count` header with the total number of items. This allows applications to display a progress bar or similar while fetching pages.

## Override page detections and options

You can override the page detection by creating a method `page` in your controller that returns the page index as a numeric:

```ruby
class ApplicationController
  def page
    params[:seite].to_i # seite means page in German
  end
end
```

The same applies to `per_page` and `max_per_page`:

```ruby
class ApplicationController
  def per_page
    10
  end

  def max_per_page
    25
  end
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Add tests for your feature.
4. Add your feature.
5. Commit your changes (`git commit -am 'Add some feature'`)
6. Push to the branch (`git push origin my-new-feature`)
7. Create new Pull Request

## License

[MIT License](http://www.opensource.org/licenses/mit-license.php)

Copyright © 2013-2025, Jan Graichen
