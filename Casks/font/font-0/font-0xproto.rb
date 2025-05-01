cask "font-0xproto" do
  version "2.400"
  sha256 "b34ee80633a2cfe6725dd5a9ab892f55eb321c7a7f6b7f561f1d9f7d87c2ba65"

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