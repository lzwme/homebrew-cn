cask "font-iosevka-ss08" do
  version "28.0.6"
  sha256 "275ca324d72655369cc094db09bb92299da6eb79524b7a08e38edb4899e016c0"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS08-#{version}.zip"
  name "Iosevka SS08"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS08-Bold.ttc"
  font "IosevkaSS08-ExtraBold.ttc"
  font "IosevkaSS08-ExtraLight.ttc"
  font "IosevkaSS08-Heavy.ttc"
  font "IosevkaSS08-Light.ttc"
  font "IosevkaSS08-Medium.ttc"
  font "IosevkaSS08-Regular.ttc"
  font "IosevkaSS08-SemiBold.ttc"
  font "IosevkaSS08-Thin.ttc"

  # No zap stanza required
end