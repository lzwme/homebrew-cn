cask "font-iosevka-ss12" do
  version "29.0.4"
  sha256 "949821393d0107db311771acfb24f199f57369f2ba461e19c7569659e9b9aae0"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS12-#{version}.zip"
  name "Iosevka SS12"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS12-Bold.ttc"
  font "IosevkaSS12-ExtraBold.ttc"
  font "IosevkaSS12-ExtraLight.ttc"
  font "IosevkaSS12-Heavy.ttc"
  font "IosevkaSS12-Light.ttc"
  font "IosevkaSS12-Medium.ttc"
  font "IosevkaSS12-Regular.ttc"
  font "IosevkaSS12-SemiBold.ttc"
  font "IosevkaSS12-Thin.ttc"

  # No zap stanza required
end