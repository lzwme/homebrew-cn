cask "font-space-mono-nerd-font" do
  version "3.2.1"
  sha256 "44f9138a42bc4c04007cf9230ebc55d790fbb2a40b9f88047aebc2b8ff4aa253"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}SpaceMono.zip"
  name "SpaceMono Nerd Font (Space Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "SpaceMonoNerdFont-Bold.ttf"
  font "SpaceMonoNerdFont-BoldItalic.ttf"
  font "SpaceMonoNerdFont-Italic.ttf"
  font "SpaceMonoNerdFont-Regular.ttf"
  font "SpaceMonoNerdFontMono-Bold.ttf"
  font "SpaceMonoNerdFontMono-BoldItalic.ttf"
  font "SpaceMonoNerdFontMono-Italic.ttf"
  font "SpaceMonoNerdFontMono-Regular.ttf"
  font "SpaceMonoNerdFontPropo-Bold.ttf"
  font "SpaceMonoNerdFontPropo-BoldItalic.ttf"
  font "SpaceMonoNerdFontPropo-Italic.ttf"
  font "SpaceMonoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end