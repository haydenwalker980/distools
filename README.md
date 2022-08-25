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

## Licensing
Distools is licensed under version 3 of the GNU General Public License.
Copyright (C) 2022 Hayden Walker.

This program is free software: you can redistribute it and/or modify it 
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option) 
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
