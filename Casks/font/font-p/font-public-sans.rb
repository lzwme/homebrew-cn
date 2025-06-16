cask "font-public-sans" do
  version "2.001"
  sha256 "88cacdf7cd03b31af8f1f83e1f51e0eb5a6052565a6c014c90c385f1ff2d13a5"

  url "https:github.comuswdspublic-sansreleasesdownloadv#{version}public-sans-v#{version}.zip",
      verified: "github.comuswdspublic-sans"
  name "Public Sans"
  homepage "https:public-sans.digital.gov"

  no_autobump! because: :requires_manual_review

  font "fontsotfPublicSans-Black.otf"
  font "fontsotfPublicSans-BlackItalic.otf"
  font "fontsotfPublicSans-Bold.otf"
  font "fontsotfPublicSans-BoldItalic.otf"
  font "fontsotfPublicSans-ExtraBold.otf"
  font "fontsotfPublicSans-ExtraBoldItalic.otf"
  font "fontsotfPublicSans-ExtraLight.otf"
  font "fontsotfPublicSans-ExtraLightItalic.otf"
  font "fontsotfPublicSans-Italic.otf"
  font "fontsotfPublicSans-Light.otf"
  font "fontsotfPublicSans-LightItalic.otf"
  font "fontsotfPublicSans-Medium.otf"
  font "fontsotfPublicSans-MediumItalic.otf"
  font "fontsotfPublicSans-Regular.otf"
  font "fontsotfPublicSans-SemiBold.otf"
  font "fontsotfPublicSans-SemiBoldItalic.otf"
  font "fontsotfPublicSans-Thin.otf"
  font "fontsotfPublicSans-ThinItalic.otf"
  font "fontsvariablePublicSans-Italic[wght].ttf"
  font "fontsvariablePublicSans[wght].ttf"

  # No zap stanza required
end