cask "font-geist-mono" do
  version "1.4.2"
  sha256 "e94caf733a6b019a0d4d97da9548c2ca8cbe4b2703ef1d07113a82d9e774cfe5"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}geist-font-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Mono"
  homepage "https:vercel.comfontmono"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "geist-font-#{version}fontsGeistMonootfGeistMono-Black.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Bold.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Light.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Medium.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Regular.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-SemiBold.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-Thin.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-UltraBlack.otf"
  font "geist-font-#{version}fontsGeistMonootfGeistMono-UltraLight.otf"
  font "geist-font-#{version}fontsGeistMonovariableGeistMono[wght].ttf"

  # No zap stanza required
end