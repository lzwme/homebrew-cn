cask "font-maple-mono" do
  version "7.1"
  sha256 "eda14c302c6b7830f62a7a6022dfe0718032a7ea4d12d75f4a04ffe1a38cfcff"

  url "https:github.comsubframe7536Maple-fontreleasesdownloadv#{version}MapleMono-TTF.zip",
      verified: "github.comsubframe7536Maple-font"
  name "Maple Mono"
  homepage "https:font.subf.deven"

  livecheck do
    url :url
    regex(^v?(\d+(?:\.\d+)+(?:-beta\d+)?)$i)
    strategy :github_latest
  end

  font "MapleMono-Bold.ttf"
  font "MapleMono-BoldItalic.ttf"
  font "MapleMono-ExtraBold.ttf"
  font "MapleMono-ExtraBoldItalic.ttf"
  font "MapleMono-ExtraLight.ttf"
  font "MapleMono-ExtraLightItalic.ttf"
  font "MapleMono-Italic.ttf"
  font "MapleMono-Light.ttf"
  font "MapleMono-LightItalic.ttf"
  font "MapleMono-Medium.ttf"
  font "MapleMono-MediumItalic.ttf"
  font "MapleMono-Regular.ttf"
  font "MapleMono-SemiBold.ttf"
  font "MapleMono-SemiBoldItalic.ttf"
  font "MapleMono-Thin.ttf"
  font "MapleMono-ThinItalic.ttf"

  # No zap stanza required
end