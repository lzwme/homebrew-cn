cask "font-simple-icons" do
  version "15.0.0"
  sha256 "6241ff475e0fab70d82ad98e711764be546280c373b02dcc211a39034304903f"

  url "https:github.comsimple-iconssimple-icons-fontreleasesdownload#{version}simple-icons-font-#{version}.zip",
      verified: "github.comsimple-iconssimple-icons-font"
  name "Simple Icons"
  homepage "https:simpleicons.org"

  font "fontSimpleIcons-Fit.otf"
  font "fontSimpleIcons.otf"

  # No zap stanza required
end