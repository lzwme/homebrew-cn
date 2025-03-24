cask "font-cozette" do
  version "1.27.0"
  sha256 "ce3435f89bad4e6fcc1faf45fb9cfcb62473a07b6b8f5f709973f9cb4df643d0"

  url "https:github.comslavfoxCozettereleasesdownloadv.#{version}CozetteFonts-v-#{version.dots_to_hyphens}.zip"
  name "Cozette"
  homepage "https:github.comslavfoxCozette"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "CozetteFontsCozetteCrossedSevenVector.otf"
  font "CozetteFontsCozetteCrossedSevenVectorBold.otf"
  font "CozetteFontsCozetteVector.otf"
  font "CozetteFontsCozetteVectorBold.otf"

  # No zap stanza required
end