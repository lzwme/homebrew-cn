cask "font-pixel-code" do
  version "2.2"
  sha256 "528128a720941a84cb006b1c21f7695f7d8035a09e5cb1226c387d4c141c4b32"

  url "https:github.comqwerasd205PixelCodereleasesdownloadv#{version}otf.zip",
      verified: "github.comqwerasd205PixelCode"
  name "Pixel Code"
  homepage "https:qwerasd205.github.ioPixelCode"

  no_autobump! because: :requires_manual_review

  font "otfPixelCode.otf"
  font "otfPixelCode-Black-Italic.otf"
  font "otfPixelCode-Black.otf"
  font "otfPixelCode-Bold-Italic.otf"
  font "otfPixelCode-Bold.otf"
  font "otfPixelCode-DemiBold-Italic.otf"
  font "otfPixelCode-DemiBold.otf"
  font "otfPixelCode-ExtraBlack-Italic.otf"
  font "otfPixelCode-ExtraBlack.otf"
  font "otfPixelCode-ExtraBold-Italic.otf"
  font "otfPixelCode-ExtraBold.otf"
  font "otfPixelCode-ExtraLight-Italic.otf"
  font "otfPixelCode-ExtraLight.otf"
  font "otfPixelCode-Italic.otf"
  font "otfPixelCode-Light-Italic.otf"
  font "otfPixelCode-Light.otf"
  font "otfPixelCode-Medium-Italic.otf"
  font "otfPixelCode-Medium.otf"
  font "otfPixelCode-Thin-Italic.otf"
  font "otfPixelCode-Thin.otf"

  # No zap stanza required
end