cask "font-geist-mono" do
  version "1.4.0"
  sha256 "0ef8aaa0ac16f8a6b8240df45eeb0a31e6c5ffde5b2523611e9c5c0f3c41b1ea"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}GeistMono-v#{version}.zip",
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