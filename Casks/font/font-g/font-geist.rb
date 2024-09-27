cask "font-geist" do
  version "1.4.0"
  sha256 "1bd906111a8853f0720831d08a363077358afc755acf893c6d4ed29529bef139"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}Geist-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist"
  homepage "https:vercel.comfontsans"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "GeistotfGeist-Black.otf"
  font "GeistotfGeist-Bold.otf"
  font "GeistotfGeist-ExtraBold.otf"
  font "GeistotfGeist-ExtraLight.otf"
  font "GeistotfGeist-Light.otf"
  font "GeistotfGeist-Medium.otf"
  font "GeistotfGeist-Regular.otf"
  font "GeistotfGeist-SemiBold.otf"
  font "GeistotfGeist-Thin.otf"
  font "GeistvariableGeist[wght].ttf"

  # No zap stanza required
end