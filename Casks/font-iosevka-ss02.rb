cask "font-iosevka-ss02" do
  version "29.0.4"
  sha256 "02571b988fcd8640ad0e124864d1d9b571762f2bf4667204dc6eb07057607f89"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaSS02-#{version}.zip"
  name "Iosevka SS02"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaSS02-Bold.ttc"
  font "IosevkaSS02-ExtraBold.ttc"
  font "IosevkaSS02-ExtraLight.ttc"
  font "IosevkaSS02-Heavy.ttc"
  font "IosevkaSS02-Light.ttc"
  font "IosevkaSS02-Medium.ttc"
  font "IosevkaSS02-Regular.ttc"
  font "IosevkaSS02-SemiBold.ttc"
  font "IosevkaSS02-Thin.ttc"

  # No zap stanza required
end