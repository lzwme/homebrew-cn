cask "font-geist" do
  version "1.1.0"
  sha256 "8f96b6e69f416706cec3293ceaa4cbb41a981cba7a32ed7c92dff14a5a44497e"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}Geist.zip",
      verified: "github.comvercelgeist-font"
  name "Geist"
  desc "Sans-serif typeface"
  homepage "https:vercel.comfontsans"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "GeistGeist-Black.otf"
  font "GeistGeist-Bold.otf"
  font "GeistGeist-Light.otf"
  font "GeistGeist-Medium.otf"
  font "GeistGeist-Regular.otf"
  font "GeistGeist-SemiBold.otf"
  font "GeistGeist-Thin.otf"
  font "GeistGeist-UltraBlack.otf"
  font "GeistGeist-UltraLight.otf"
  font "GeistGeistVariableVF.ttf"

  # No zap stanza required
end