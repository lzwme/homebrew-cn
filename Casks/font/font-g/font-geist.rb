cask "font-geist" do
  version "1.4.01"
  sha256 "b013dce423d16c03238593f6b8e0a281322bafdc2a75b376a91de8721cf18315"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}Geist-v#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist"
  homepage "https:vercel.comfontsans"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "otfGeist-Black.otf"
  font "otfGeist-Bold.otf"
  font "otfGeist-ExtraBold.otf"
  font "otfGeist-ExtraLight.otf"
  font "otfGeist-Light.otf"
  font "otfGeist-Medium.otf"
  font "otfGeist-Regular.otf"
  font "otfGeist-SemiBold.otf"
  font "otfGeist-Thin.otf"
  font "variableGeist[wght].ttf"

  # No zap stanza required
end