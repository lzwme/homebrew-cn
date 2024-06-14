cask "font-geist" do
  version "1.3.0"
  sha256 "6a656e5efc991a0b465bc288b5455eebd7219e0668a936f8705a2e9d3a2a62c9"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}Geist-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist"
  homepage "https:vercel.comfontsans"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Geist-#{version}statics-otfGeist-Black.otf"
  font "Geist-#{version}statics-otfGeist-Bold.otf"
  font "Geist-#{version}statics-otfGeist-Light.otf"
  font "Geist-#{version}statics-otfGeist-Medium.otf"
  font "Geist-#{version}statics-otfGeist-Regular.otf"
  font "Geist-#{version}statics-otfGeist-SemiBold.otf"
  font "Geist-#{version}statics-otfGeist-Thin.otf"
  font "Geist-#{version}statics-otfGeist-UltraBlack.otf"
  font "Geist-#{version}statics-otfGeist-UltraLight.otf"
  font "Geist-#{version}variable-ttfGeistVF.ttf"

  # No zap stanza required
end