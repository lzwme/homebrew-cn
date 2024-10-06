cask "font-geist-mono" do
  version "1.4.0"
  sha256 "70423ceba8d5f768a9a9a9cb56c449a5307d20679d951113acdf38d7107a548b"

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