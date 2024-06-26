cask "font-meslo-for-powerline" do
  version "2015-12-04"
  sha256 "3a0b73abca6334b5e6bddefab67f6eb1b2fac1231817d95fc79126c8998c4844"

  url "https:github.compowerlinefontsarchiverefstags#{version}.tar.gz"
  name "Meslo for Powerline"
  homepage "https:github.compowerlinefonts"

  font "fonts-#{version}MesloMeslo LG L DZ Regular for Powerline.otf"
  font "fonts-#{version}MesloMeslo LG L Regular for Powerline.otf"
  font "fonts-#{version}MesloMeslo LG M DZ Regular for Powerline.otf"
  font "fonts-#{version}MesloMeslo LG M Regular for Powerline.otf"
  font "fonts-#{version}MesloMeslo LG S DZ Regular for Powerline.otf"
  font "fonts-#{version}MesloMeslo LG S Regular for Powerline.otf"

  # No zap stanza required
end