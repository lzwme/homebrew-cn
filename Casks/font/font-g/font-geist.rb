cask "font-geist" do
  version "1.4.0"
  sha256 "b2c99487cd205def10ce8ab4b2ca045426c5c0e60f9707ec53c31146c63eb7b2"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}Geist-v#{version}.zip",
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