cask "font-iosevka-ss01" do
  version "31.1.0"
  sha256 "a9c4e60d1cb5d3998c4f496b91ff8e4a97fdb9210a1957a95ba954dcbdafb6de"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS01-#{version}.zip"
  name "Iosevka SS01"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS01-Bold.ttc"
  font "IosevkaSS01-ExtraBold.ttc"
  font "IosevkaSS01-ExtraLight.ttc"
  font "IosevkaSS01-Heavy.ttc"
  font "IosevkaSS01-Light.ttc"
  font "IosevkaSS01-Medium.ttc"
  font "IosevkaSS01-Regular.ttc"
  font "IosevkaSS01-SemiBold.ttc"
  font "IosevkaSS01-Thin.ttc"

  # No zap stanza required
end