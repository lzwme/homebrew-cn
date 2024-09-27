cask "font-geist-mono" do
  version "1.4.0"
  sha256 "91721f29a42d7e9e87348cd2db49a8f41c9363e43665be8c3aa44564c3e0cd3d"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}GeistMono-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Mono"
  homepage "https:vercel.comfontmono"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "GeistMonootfGeistMono-Black.otf"
  font "GeistMonootfGeistMono-Bold.otf"
  font "GeistMonootfGeistMono-Light.otf"
  font "GeistMonootfGeistMono-Medium.otf"
  font "GeistMonootfGeistMono-Regular.otf"
  font "GeistMonootfGeistMono-SemiBold.otf"
  font "GeistMonootfGeistMono-Thin.otf"
  font "GeistMonootfGeistMono-UltraBlack.otf"
  font "GeistMonootfGeistMono-UltraLight.otf"
  font "GeistMonovariableGeistMono[wght].ttf"

  # No zap stanza required
end