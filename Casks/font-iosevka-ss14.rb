cask "font-iosevka-ss14" do
  version "28.0.5"
  sha256 "7bd4bf4be5ca1bcfc0d16d0b7634034028069d1484bf68e1b8d372f84636843f"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS14-#{version}.zip"
  name "Iosevka SS14"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS14-Bold.ttc"
  font "IosevkaSS14-ExtraBold.ttc"
  font "IosevkaSS14-ExtraLight.ttc"
  font "IosevkaSS14-Heavy.ttc"
  font "IosevkaSS14-Light.ttc"
  font "IosevkaSS14-Medium.ttc"
  font "IosevkaSS14-Regular.ttc"
  font "IosevkaSS14-SemiBold.ttc"
  font "IosevkaSS14-Thin.ttc"

  # No zap stanza required
end