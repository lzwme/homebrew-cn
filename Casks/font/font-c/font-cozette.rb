cask "font-cozette" do
  version "1.25.2"
  sha256 "0ee8292f9273b56e64c19e3a4d978d6f5c4b091220ec129083287d99a059cd18"

  url "https:github.comslavfoxCozettereleasesdownloadv.#{version}CozetteFonts-v-#{version.dots_to_hyphens}.zip"
  name "Cozette"
  homepage "https:github.comslavfoxCozette"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "CozetteFontsCozetteVector.otf"
  font "CozetteFontsCozetteVectorBold.otf"

  # No zap stanza required
end