cask "font-stix" do
  version "2.14"
  sha256 "b9ce7effe9cf97185bc3bfd9b3c5e79e0928a500127d1f55d0a704e04d274420"

  url "https:github.comstipubstixfontsreleasesdownloadv#{version}fonts.zip",
      verified: "github.comstipubstixfonts"
  name "STIX"
  homepage "https:stixfonts.org"

  font "fontsSTIXTwoMathOTFSTIXTwoMath.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-Bold.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-BoldItalic.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-Italic.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-Medium.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-MediumItalic.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-Regular.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-SemiBold.otf"
  font "fontsSTIXTwoTextOTFSTIXTwoText-SemiBoldItalic.otf"

  # No zap stanza required
end