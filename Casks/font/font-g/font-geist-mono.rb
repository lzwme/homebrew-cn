cask "font-geist-mono" do
  version "1.4.01"
  sha256 "ae3112093f124621ec579c3849167df954f80feacd7870bfcc2f62f739830fc1"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}GeistMono-v#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Mono"
  homepage "https:vercel.comfontmono"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "otfGeistMono-Black.otf"
  font "otfGeistMono-Bold.otf"
  font "otfGeistMono-Light.otf"
  font "otfGeistMono-Medium.otf"
  font "otfGeistMono-Regular.otf"
  font "otfGeistMono-SemiBold.otf"
  font "otfGeistMono-Thin.otf"
  font "otfGeistMono-UltraBlack.otf"
  font "otfGeistMono-UltraLight.otf"
  font "variableGeistMono[wght].ttf"

  # No zap stanza required
end