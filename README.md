# Paginate::Responder

A Rails pagination responder with link header support.

## Installation

Add this line to your application's Gemfile:

    gem 'paginate-responder'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install paginate-responder

You will also need a pagination gem like
[will_paginate](mislav/will_paginate).

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

Or use it with [plataformatec/responders](https://github.com/plataformatec/responders):

```ruby
class MyController < ApplicationController
  responders Responders::PaginateResponder
end
```

`PaginateResponder` will add the following link headers to
non HTML responses:

* *first* First page's URL.
* *last* Last page's URL.
* *next* Next page's URL.
* *prev* Previous page's URL.

Next and previous page links will not be added if current
page is first or last page.

Also a `X-Total-Pages` header will be added with the total
number of pages if available. This allows applications
to display a progress bar or similar while fetching pages.

`PaginateResponder` should work with any pagination gem that
adds a `paginate` method to collections. Tests run with
[will_paginate](mislav/will_paginate).

The `total_pages` method on the collection will be used as
total page count. If not total page method is present or
nil is returned some link header may be missing.

## TODOs

* Documentation
** Controller methods

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

Copyright (c) 2013, Jan Graichen
