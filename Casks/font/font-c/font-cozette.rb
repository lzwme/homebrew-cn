cask "font-cozette" do
  version "1.28.0"
  sha256 "18edb5af56a38b4a4fcc5772ccab38069a669682d28c45bedd899eda30853d72"

  url "https:github.comslavfoxCozettereleasesdownloadv.#{version}CozetteFonts-v-#{version.dots_to_hyphens}.zip"
  name "Cozette"
  homepage "https:github.comslavfoxCozette"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "CozetteFontscozette.dfont"
  font "CozetteFontscozette_hidpi.dfont"
  font "CozetteFontsCozetteCrossedSevenVector.otf"
  font "CozetteFontsCozetteCrossedSevenVectorBold.otf"
  font "CozetteFontsCozetteVector.otf"
  font "CozetteFontsCozetteVectorBold.otf"

  # No zap stanza required
end