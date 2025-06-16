cask "font-0xproto-nerd-font" do
  version "3.4.0"
  sha256 "e50e7fec9efbe1eb986b65f01e210098e122a3f495db24e6624bdcbca52da11d"

  url "https:github.comryanoasisnerd-fontsreleasesdownloadv#{version}0xProto.zip"
  name "0xProto Nerd Font (0xProto)"
  homepage "https:github.comryanoasisnerd-fonts"

  no_autobump! because: :bumped_by_upstream

  livecheck do
    url :url
    strategy :github_latest
  end

  font "0xProtoNerdFont-Bold.ttf"
  font "0xProtoNerdFont-Italic.ttf"
  font "0xProtoNerdFont-Regular.ttf"
  font "0xProtoNerdFontMono-Bold.ttf"
  font "0xProtoNerdFontMono-Italic.ttf"
  font "0xProtoNerdFontMono-Regular.ttf"
  font "0xProtoNerdFontPropo-Bold.ttf"
  font "0xProtoNerdFontPropo-Italic.ttf"
  font "0xProtoNerdFontPropo-Regular.ttf"

  # No zap stanza required
end