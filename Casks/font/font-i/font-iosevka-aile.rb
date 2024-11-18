cask "font-iosevka-aile" do
  version "32.1.0"
  sha256 "e4bf2e8169d1f1fb4e7f9cc5fb327ec59b0e890796e89e65992f3cf3c3b956c5"

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