cask "font-iosevka" do
  version "30.1.2"
  sha256 "f9ae228b8dce6cec5d44201a91234b450d1677c8b4ac24c6ee185f6f716673eb"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-Iosevka-#{version}.zip"
  name "Iosevka"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Iosevka-Bold.ttc"
  font "Iosevka-ExtraBold.ttc"
  font "Iosevka-ExtraLight.ttc"
  font "Iosevka-Heavy.ttc"
  font "Iosevka-Light.ttc"
  font "Iosevka-Medium.ttc"
  font "Iosevka-Regular.ttc"
  font "Iosevka-SemiBold.ttc"
  font "Iosevka-Thin.ttc"

  # No zap stanza required
end