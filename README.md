# Distools
Very customizable Discord bot written in Discorb.

## Pardon the dust!

Distools is undergoing a massive rewrite. It'll still be open source, it'll just be able to do more.

## Development Quickstart

### Dependencies
- MongoDB
- Bundler
- Ruby 3.0.0 (`rvm` recommended)
- A decent computer
- Discorb

### Hosting
- Run `bundle install`
- It is recommended to also run `gem install discorb`
- Copy .env.sample to .env, and fill in the values (only TOKEN and ID are required)
- If you installed discorb via gem, run `discorb setup`, otherwise if you installed via Bundler, run `bundle exec discorb setup`
- Modify `main.rb` and the files in `config/` to your values
- `bin/start` and enjoy.

## Code of Conduct

Everyone interacting in the Distools project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://gh.windev.systems/hwalker/distools/blob/master/CODE_OF_CONDUCT.md).
