cask "font-0xproto" do
  version "2.500"
  sha256 "eb7a786c9f4b4d89c6c8e4cf406f96b21f13464ed8b9631db30002045a5ac794"

  url "https:github.com0xType0xProtoreleasesdownload#{version}0xProto_#{version.dots_to_underscores}.zip"
  name "0xProto"
  homepage "https:github.com0xType0xProto"

  font "0xProto-Bold.otf"
  font "0xProto-Regular.otf"
  font "0xProto-Italic.otf"
  font "No-Ligatures0xProto-Bold-NL.otf"
  font "No-Ligatures0xProto-Italic-NL.otf"
  font "No-Ligatures0xProto-Regular-NL.otf"
  font "ZxProtoZxProto-Bold.otf"
  font "ZxProtoZxProto-Italic.otf"
  font "ZxProtoZxProto-Regular.otf"

  # No zap stanza required
end