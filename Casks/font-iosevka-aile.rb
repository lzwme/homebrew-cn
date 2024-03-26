cask "font-iosevka-aile" do
  version "29.0.4"
  sha256 "d0520f812775545e7f153bd0151cc75dd9830c4443e1a0b0ef3e82a988cc9f21"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}PkgTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  desc "Sans-serif, slab-serif, monospace and quasi‑proportional typeface family"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile-Bold.ttc"
  font "IosevkaAile-ExtraBold.ttc"
  font "IosevkaAile-ExtraLight.ttc"
  font "IosevkaAile-Heavy.ttc"
  font "IosevkaAile-Light.ttc"
  font "IosevkaAile-Medium.ttc"
  font "IosevkaAile-Regular.ttc"
  font "IosevkaAile-SemiBold.ttc"
  font "IosevkaAile-Thin.ttc"

  # No zap stanza required
end