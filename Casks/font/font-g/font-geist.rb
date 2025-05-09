cask "font-geist" do
  version "1.4.2"
  sha256 "e94caf733a6b019a0d4d97da9548c2ca8cbe4b2703ef1d07113a82d9e774cfe5"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}geist-font-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist"
  homepage "https:vercel.comfontsans"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "geist-font-#{version}fontsGeistotfGeist-Black.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Bold.otf"
  font "geist-font-#{version}fontsGeistotfGeist-ExtraBold.otf"
  font "geist-font-#{version}fontsGeistotfGeist-ExtraLight.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Light.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Medium.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Regular.otf"
  font "geist-font-#{version}fontsGeistotfGeist-SemiBold.otf"
  font "geist-font-#{version}fontsGeistotfGeist-Thin.otf"
  font "geist-font-#{version}fontsGeistvariableGeist[wght].ttf"

  # No zap stanza required
end