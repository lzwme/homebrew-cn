cask "font-iosevka-aile" do
  version "31.2.0"
  sha256 "da37fed954ea26ad97cb5c05c16ba305736dfb8d72afc0f65240fa7fd52b81f0"

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