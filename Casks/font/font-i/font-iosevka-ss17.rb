cask "font-iosevka-ss17" do
  version "30.1.2"
  sha256 "0e9675a36fdef05737d07d15429103860c8f9ca46fbfdf9d2929ed1dbf94fb57"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS17-#{version}.zip"
  name "Iosevka SS17"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS17-Bold.ttc"
  font "IosevkaSS17-ExtraBold.ttc"
  font "IosevkaSS17-ExtraLight.ttc"
  font "IosevkaSS17-Heavy.ttc"
  font "IosevkaSS17-Light.ttc"
  font "IosevkaSS17-Medium.ttc"
  font "IosevkaSS17-Regular.ttc"
  font "IosevkaSS17-SemiBold.ttc"
  font "IosevkaSS17-Thin.ttc"

  # No zap stanza required
end