cask "font-iosevka-ss18" do
  version "29.0.4"
  sha256 "0702200ff74eb0a0f25e64ada7525db417cd7cb9e74405d21524bd99fc4d48fa"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS18-#{version}.zip"
  name "Iosevka SS18"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS18-Bold.ttc"
  font "IosevkaSS18-ExtraBold.ttc"
  font "IosevkaSS18-ExtraLight.ttc"
  font "IosevkaSS18-Heavy.ttc"
  font "IosevkaSS18-Light.ttc"
  font "IosevkaSS18-Medium.ttc"
  font "IosevkaSS18-Regular.ttc"
  font "IosevkaSS18-SemiBold.ttc"
  font "IosevkaSS18-Thin.ttc"

  # No zap stanza required
end