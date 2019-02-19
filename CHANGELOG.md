# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 1.8.0 - 2019-02-19
### Added
* Support for pagination using `pagy` gem (#14)

### Fixed
* sqlite3 version conflict in active_record (#15)
* Invalid ?page parameter could cause exceptions (#16)

## 1.7.0

* Add `X-Current-Page` header (#10)

## 1.6.0

* Large rewrite of adapters to provide more customizable logic
* Add controller hook for adapter initialization

## 1.5.0

* Adjust `per_page` parameter if max-per-page limit is exceeded (#6)
* Add `X-Per-Page` header (#7)

## 1.4.2

* Fix performance issue with adapter lookup

## 1.4.1

* Fix issue with non-paginated resources

## 1.4.0

* Add `X-Total-Count` header (#4)

## 1.3.0

* Fix issues with adapter selection

## 1.2.0

* Add kaminari support
* Fix issue with missing #each on Fixnum in header generation

## 1.1.0

* Generate Link header using `rack-link_headers`
