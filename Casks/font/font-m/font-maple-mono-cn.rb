cask "font-maple-mono-cn" do
  version "7.1"
  sha256 "0f807e2809326ef7d54be1f3b68613085f90b3d971ae1d5d7b66c13d405d3baf"

  url "https:github.comsubframe7536Maple-fontreleasesdownloadv#{version}MapleMono-CN-unhinted.zip",
      verified: "github.comsubframe7536Maple-font"
  name "Maple Mono CN"
  homepage "https:font.subf.deven"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMono-CN-Bold.ttf"
  font "MapleMono-CN-BoldItalic.ttf"
  font "MapleMono-CN-ExtraBold.ttf"
  font "MapleMono-CN-ExtraBoldItalic.ttf"
  font "MapleMono-CN-ExtraLight.ttf"
  font "MapleMono-CN-ExtraLightItalic.ttf"
  font "MapleMono-CN-Italic.ttf"
  font "MapleMono-CN-Light.ttf"
  font "MapleMono-CN-LightItalic.ttf"
  font "MapleMono-CN-Medium.ttf"
  font "MapleMono-CN-MediumItalic.ttf"
  font "MapleMono-CN-Regular.ttf"
  font "MapleMono-CN-SemiBold.ttf"
  font "MapleMono-CN-SemiBoldItalic.ttf"
  font "MapleMono-CN-Thin.ttf"
  font "MapleMono-CN-ThinItalic.ttf"

  # No zap stanza required
end