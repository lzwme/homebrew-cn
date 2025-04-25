cask "font-droid-sans-mono-nerd-font" do
  version "3.4.0"
  sha256 "030229341907c833862f00682f0f4bce65d0dc8d281fc9a40d80b7ee9d306e88"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}DroidSansMono.zip"
  name "DroidSansM Nerd Font (Droid Sans Mono)"
  homepage "https:github.comryanoasisnerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "DroidSansMNerdFont-Regular.otf"
  font "DroidSansMNerdFontMono-Regular.otf"
  font "DroidSansMNerdFontPropo-Regular.otf"

  # No zap stanza required
end