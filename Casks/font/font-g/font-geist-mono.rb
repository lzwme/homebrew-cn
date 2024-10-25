cask "font-geist-mono" do
  version "1.4.01"
  sha256 "2338de729353fa25e62581f87be9d6620ec246eac28179c2c2c9f77e5fdfa548"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}GeistMono-#{version}.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Mono"
  homepage "https:vercel.comfontmono"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "GeistMono-#{version}otfGeistMono-Black.otf"
  font "GeistMono-#{version}otfGeistMono-Bold.otf"
  font "GeistMono-#{version}otfGeistMono-Light.otf"
  font "GeistMono-#{version}otfGeistMono-Medium.otf"
  font "GeistMono-#{version}otfGeistMono-Regular.otf"
  font "GeistMono-#{version}otfGeistMono-SemiBold.otf"
  font "GeistMono-#{version}otfGeistMono-Thin.otf"
  font "GeistMono-#{version}otfGeistMono-UltraBlack.otf"
  font "GeistMono-#{version}otfGeistMono-UltraLight.otf"
  font "GeistMono-#{version}variableGeistMono[wght].ttf"

  # No zap stanza required
end