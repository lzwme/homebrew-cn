cask "font-code-new-roman-nerd-font" do
  version "3.4.0"
  sha256 "4a3de867f398ab32d5e1a750e0149d57413952e318d0cf41d33dac57e8dabe2a"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}CodeNewRoman.zip"
  name "CodeNewRoman Nerd Font (Code New Roman)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "CodeNewRomanNerdFont-Bold.otf"
  font "CodeNewRomanNerdFont-Italic.otf"
  font "CodeNewRomanNerdFont-Regular.otf"
  font "CodeNewRomanNerdFontMono-Bold.otf"
  font "CodeNewRomanNerdFontMono-Italic.otf"
  font "CodeNewRomanNerdFontMono-Regular.otf"
  font "CodeNewRomanNerdFontPropo-Bold.otf"
  font "CodeNewRomanNerdFontPropo-Italic.otf"
  font "CodeNewRomanNerdFontPropo-Regular.otf"

  # No zap stanza required
end