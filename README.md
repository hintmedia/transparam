# Transparam

> :warning: **Alpha quality**: While Transparam has been used at Hint for a couple of years now, it should be considered alpha quality. Your mileage may vary! Also, please see the [Known issues](#known-issues) below for a list of shortcomings (contribution opportunities…?).

Transparam assists in the process of migrating a rails application from `protected_attributes` to `strong_parameters`. Transparam makes some assumptions about how strong parameters should be implemented in your application. To learn more, checkout this [blog post](https://hint.io/blog/strong-parameters-strong-opinions).

For example, the User model defined here:

```ruby
class User < ActiveRecord::Base
  attr_accessible :email, :phone_numbers_attributes

  has_many :phone_numbers

  accepts_nested_attributes_for :phone_numbers, update_only: true, allow_destroy: true
end

class PhoneNumber < ActiveRecord::Base
  attr_accessible :number

  belongs_to :users
end
```

Will result in this strong parameters concern:

```ruby
# app/controllers/concerns/strong_parameters/user.rb
module Concerns
  module StrongParameters
    module User
      def user_params
        params.require(:user).moderate(controller_name, action_name, *Concerns::StrongParameters::User.permitted_attrs)
      end

      def self.permitted_attrs
        [
          :email,
          { :phone_numbers_attributes => [:_destroy, *Concerns::StrongParameters::PhoneNumber.permitted_attrs] }
        ]
      end
    end
  end
end
```

## Usage

From the root of the target rails application run the generate command:

`transparam generate`

Transparam performs dynamic analysis and thus requires a working development environment.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Known issues

- `attr_protected` is not yet supported.
- Multiple roles are not yet supported (example `as: :admin`).
- Only [moderate_parameters](https://github.com/hintmedia/moderate_parameters) is supported (`.permit` vs `.moderate`). Ideally this would be configurable.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hintmedia/transparam. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hintmedia/transparam/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Transparam project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hintmedia/transparam/blob/master/CODE_OF_CONDUCT.md).
