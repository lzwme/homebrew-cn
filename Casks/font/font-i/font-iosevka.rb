cask "font-iosevka" do
  version "31.3.0"
  sha256 "aa8da7aab09f8eb8f813e082ab08c950ba464c987c144ac4d3e8339f20266084"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-Iosevka-#{version}.zip"
  name "Iosevka"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Iosevka.ttc"

  # No zap stanza required
end