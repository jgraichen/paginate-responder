# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

- Dropped unsupported Ruby and Rails versions from test matrix

### Added

- Added Rails 6.1 + 7.0 and Ruby 3.0 to new GitHub Actions test pipeline
- Added Rails 7.1 and Ruby 3.1, 3.2, 3.3 to test matrix
- Added Ruby 3.4 and Rails 7.2+ to test matrix

### Fixed

- Fix header case issues in test suite with Rails 7.1

## 2.1.0 - 2019-02-28

### Added

- Respond with pagination link headers to HEAD requests (#12)

## 2.0.0 - 2019-02-19

### Changed

- Override respond, not to_format for compatibility with decorate-responder 2.0 (#17)

## 1.8.0 - 2019-02-19

### Added

- Support for pagination using `pagy` gem (#14)

### Fixed

- sqlite3 version conflict in active_record (#15)
- Invalid ?page parameter could cause exceptions (#16)

## 1.7.0 - 2017-06-02

### Changed

- Add `X-Current-Page` header (#10)

## 1.6.0 - 2016-11-08

### Changed

- Large rewrite of adapters to provide more customizable logic
- Add controller hook for adapter initialization

## 1.5.0 - 2016-04-06

### Changed

- Adjust `per_page` parameter if max-per-page limit is exceeded (#6)
- Add `X-Per-Page` header (#7)

## 1.4.2 - 2016-02-11

### Changed

- Fix performance issue with adapter lookup

## 1.4.1 - 2014-04-30

### Changed

- Fix issue with non-paginated resources

## 1.4.0 - 2014-04-28

### Added

- Add `X-Total-Count` header (#4)

## 1.3.0 - 2013-03-07

### Fixed

- Fix issues with adapter selection

## 1.2.0 - 2013-02-25

### Added

- Add kaminari support

### Fixed

- Fix issue with missing #each on Fixnum in header generation

## 1.1.0 - 2013-01-18

### Added

- Generate Link header using `rack-link_headers`
