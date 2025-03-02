cask "font-iosevka-aile" do
  version "33.0.0"
  sha256 "fcc677bb6e75790a5d5f1ef2ac79a5e12448e8cefa510949f8a74329512025bc"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaAile-#{version}.zip"
  name "Iosevka Aile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaAile.ttc"

  # No zap stanza required
end