cask "font-iosevka-aile" do
  version "32.0.1"
  sha256 "7f176cc9e3b6a823ea4d61b911877cde8595b42385cfbbaa774fcb1f7dce9eb2"

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