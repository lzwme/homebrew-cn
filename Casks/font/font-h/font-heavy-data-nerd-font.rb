cask "font-heavy-data-nerd-font" do
  version "3.4.0"
  sha256 "7fbe911ba18864f19afa4f97201dc8ecc4694c6c47b44d2e3dd1c13be3e63574"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}HeavyData.zip"
  name "HeavyData Nerd Font (Heavy Data)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "HeavyDataNerdFont-Regular.ttf"
  font "HeavyDataNerdFontPropo-Regular.ttf"

  # No zap stanza required
end