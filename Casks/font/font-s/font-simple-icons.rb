cask "font-simple-icons" do
  version "15.2.0"
  sha256 "37287fca9d93da6735bff1193c59d39bd2cc3f9e151fc9daec5edafaa22574dc"

  url "https:github.comsimple-iconssimple-icons-fontreleasesdownload#{version}simple-icons-font-#{version}.zip",
      verified: "github.comsimple-iconssimple-icons-font"
  name "Simple Icons"
  homepage "https:simpleicons.org"

  no_autobump! because: :requires_manual_review

  font "fontSimpleIcons-Fit.otf"
  font "fontSimpleIcons.otf"

  # No zap stanza required
end