cask "font-iosevka-ss08" do
  version "29.2.0"
  sha256 "80500d08743dde6ffcb7fcaf7f9ba62a728f0ea351b6c43d2612b74cbe507f81"

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