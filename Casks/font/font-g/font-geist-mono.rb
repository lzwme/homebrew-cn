cask "font-geist-mono" do
  version "1.5.0"
  sha256 "8a57ecad52a78d5d4f90e1ac2f8cbf1ed9479c796e52ef2e564f67c8cf06c247"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}geist-font-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Mono"
  homepage "https:vercel.comfont"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  font "geist-font-#{version}fontsGeistMonootfGeistMono-Black.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-BlackItalic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Bold.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-BoldItalic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-ExtraBold.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-ExtraBoldItalic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-ExtraLight.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-ExtraLightItalic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Italic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Light.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-LightItalic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Medium.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-MediumItalic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Regular.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-SemiBold.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-SemiBoldItalic.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Thin.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-ThinItalic.otf"
  font "geist-font-#{version}fontsGeistMonovariableGeistMono-Italic[wght].ttf"
  font "geist-font-#{version}fontsGeistMonovariableGeistMono[wght].ttf"

  # No zap stanza required
end