cask "font-geist-mono" do
  version "1.3.0"
  sha256 "d6d19b0fc600110cb1595152c803a1f08e258f76637d1509baf76e2e0b9708d5"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}GeistMono-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Mono"
  homepage "https:vercel.comfontmono"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "GeistMono-#{version}statics-otfGeistMono-Black.otf"
  font "GeistMono-#{version}statics-otfGeistMono-Bold.otf"
  font "GeistMono-#{version}statics-otfGeistMono-Light.otf"
  font "GeistMono-#{version}statics-otfGeistMono-Medium.otf"
  font "GeistMono-#{version}statics-otfGeistMono-Regular.otf"
  font "GeistMono-#{version}statics-otfGeistMono-SemiBold.otf"
  font "GeistMono-#{version}statics-otfGeistMono-Thin.otf"
  font "GeistMono-#{version}statics-otfGeistMono-UltraBlack.otf"
  font "GeistMono-#{version}statics-otfGeistMono-UltraLight.otf"
  font "GeistMono-#{version}variable-ttfGeistMonoVF.ttf"

  # No zap stanza required
end