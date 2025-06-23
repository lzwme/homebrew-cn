cask "font-simple-icons" do
  version "15.3.0"
  sha256 "56f6aa42459f30d6a74254fa874b013a8d1e83e69998022e05a8bfd0a4d4311c"

  url "https:github.comsimple-iconssimple-icons-fontreleasesdownload#{version}simple-icons-font-#{version}.zip",
      verified: "github.comsimple-iconssimple-icons-font"
  name "Simple Icons"
  homepage "https:simpleicons.org"

  font "fontSimpleIcons-Fit.otf"
  font "fontSimpleIcons.otf"

  # No zap stanza required
end