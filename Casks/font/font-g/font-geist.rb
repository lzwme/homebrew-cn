cask "font-geist" do
  version "1.5.0"
  sha256 "8a57ecad52a78d5d4f90e1ac2f8cbf1ed9479c796e52ef2e564f67c8cf06c247"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}geist-font-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Sans"
  homepage "https:vercel.comfont"

  no_autobump! because: :requires_manual_review

  livecheck do
    url :url
    strategy :github_latest
  end

  font "geist-font-#{version}fontsGeistotfGeist-Black.otf"
  font "geist-font-#{version}fontsGeistotfGeist-BlackItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Bold.otf"
  font "geist-font-#{version}fontsGeistotfGeist-BoldItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-ExtraBold.otf"
  font "geist-font-#{version}fontsGeistotfGeist-ExtraBoldItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-ExtraLight.otf"
  font "geist-font-#{version}fontsGeistotfGeist-ExtraLightItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Light.otf"
  font "geist-font-#{version}fontsGeistotfGeist-LightItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Medium.otf"
  font "geist-font-#{version}fontsGeistotfGeist-MediumItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Regular.otf"
  font "geist-font-#{version}fontsGeistotfGeist-RegularItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-SemiBold.otf"
  font "geist-font-#{version}fontsGeistotfGeist-SemiBoldItalic.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Thin.otf"
  font "geist-font-#{version}fontsGeistotfGeist-ThinItalic.otf"
  font "geist-font-#{version}fontsGeistvariableGeist-Italic[wght].ttf"
  font "geist-font-#{version}fontsGeistvariableGeist[wght].ttf"

  # No zap stanza required
end