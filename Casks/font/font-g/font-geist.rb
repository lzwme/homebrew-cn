cask "font-geist" do
  version "1.4.01"
  sha256 "d12b5e123bdd5a9facbd52ab6a24756587b086d6a76fc629a28456675bfad4e3"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}Geist-v#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist"
  homepage "https:vercel.comfontsans"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Geist-v#{version}otfGeist-Black.otf"
  font "Geist-v#{version}otfGeist-Bold.otf"
  font "Geist-v#{version}otfGeist-ExtraBold.otf"
  font "Geist-v#{version}otfGeist-ExtraLight.otf"
  font "Geist-v#{version}otfGeist-Light.otf"
  font "Geist-v#{version}otfGeist-Medium.otf"
  font "Geist-v#{version}otfGeist-Regular.otf"
  font "Geist-v#{version}otfGeist-SemiBold.otf"
  font "Geist-v#{version}otfGeist-Thin.otf"
  font "Geist-v#{version}variableGeist[wght].ttf"

  # No zap stanza required
end