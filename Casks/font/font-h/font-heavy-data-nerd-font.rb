cask "font-heavy-data-nerd-font" do
  version "3.2.1"
  sha256 "ec1b686bc31280e2596137c42907f4d924f6d0c22ba6cb2f2b84331fd6db9639"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}HeavyData.zip"
  name "HeavyData Nerd Font (Heavy Data)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "HeavyDataNerdFont-Regular.ttf"
  font "HeavyDataNerdFontPropo-Regular.ttf"

  # No zap stanza required
end