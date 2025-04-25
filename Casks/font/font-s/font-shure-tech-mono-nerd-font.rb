cask "font-shure-tech-mono-nerd-font" do
  version "3.4.0"
  sha256 "d409349fc8b47929d65d99465c18d5206ab6a42b41bce9492252dfffe1b43c32"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}ShareTechMono.zip"
  name "ShureTechMono Nerd Font (Share Tech Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "ShureTechMonoNerdFont-Regular.ttf"
  font "ShureTechMonoNerdFontMono-Regular.ttf"
  font "ShureTechMonoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end