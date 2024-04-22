cask "font-iosevka-ss03" do
  version "29.2.1"
  sha256 "6180f358d2a1c49777812bcae0744486f790e2442b3074d7dc8c1df2f435e62f"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS03-#{version}.zip"
  name "Iosevka SS03"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS03-Bold.ttc"
  font "IosevkaSS03-ExtraBold.ttc"
  font "IosevkaSS03-ExtraLight.ttc"
  font "IosevkaSS03-Heavy.ttc"
  font "IosevkaSS03-Light.ttc"
  font "IosevkaSS03-Medium.ttc"
  font "IosevkaSS03-Regular.ttc"
  font "IosevkaSS03-SemiBold.ttc"
  font "IosevkaSS03-Thin.ttc"

  # No zap stanza required
end