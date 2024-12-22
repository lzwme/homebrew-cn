cask "font-iosevka-etoile" do
  version "32.3.0"
  sha256 "573939088143695bf90be286681964d0fd93c964bd8e6702cb6608b5c6eaec4d"

  url "https:github.combe5invisIosevkareleasesdownloadv#{version}SuperTTC-IosevkaEtoile-#{version}.zip"
  name "Iosevka Etoile"
  homepage "https:github.combe5invisIosevka"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "IosevkaEtoile.ttc"

  # No zap stanza required
end