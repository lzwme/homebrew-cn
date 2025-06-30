cask "font-simple-icons" do
  version "15.4.0"
  sha256 "64fba7b5cbb6ee72ce494a97b6ea1a578ba19ae52af1039f4e443861747d217b"

  url "https:github.comsimple-iconssimple-icons-fontreleasesdownload#{version}simple-icons-font-#{version}.zip",
      verified: "github.comsimple-iconssimple-icons-font"
  name "Simple Icons"
  homepage "https:simpleicons.org"

  font "fontSimpleIcons-Fit.otf"
  font "fontSimpleIcons.otf"

  # No zap stanza required
end