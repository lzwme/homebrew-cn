cask "font-iosevka-ss13" do
  version "29.2.1"
  sha256 "90ae62fe402c910f42433baf2e2b26744cc562dca02e79f3f88df7e1d777c51a"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS13-#{version}.zip"
  name "Iosevka SS13"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS13-Bold.ttc"
  font "IosevkaSS13-ExtraBold.ttc"
  font "IosevkaSS13-ExtraLight.ttc"
  font "IosevkaSS13-Heavy.ttc"
  font "IosevkaSS13-Light.ttc"
  font "IosevkaSS13-Medium.ttc"
  font "IosevkaSS13-Regular.ttc"
  font "IosevkaSS13-SemiBold.ttc"
  font "IosevkaSS13-Thin.ttc"

  # No zap stanza required
end