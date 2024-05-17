cask "font-aurulent-sans-mono-nerd-font" do
  version "3.2.1"
  sha256 "04d850eb9c62d7d61f3f6337dbb0773d610a09a84c3e2f0ec44783bcc849ee18"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}AurulentSansMono.zip"
  name "AurulentSansM Nerd Font (Aurulent Sans Mono)"
  desc "Developer targeted fonts with a high number of glyphs"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "AurulentSansMNerdFont-Regular.otf"
  font "AurulentSansMNerdFontMono-Regular.otf"
  font "AurulentSansMNerdFontPropo-Regular.otf"

  # No zap stanza required
end