cask "font-geist-mono" do
  version "1.1.0"
  sha256 "b32e99aa5b5e7828457ce8808e8551a859089aa48d745f1b99b5a43d90dee940"

  url "https:github.comvercelgeist-fontreleasesdownload#{version}Geist.Mono.zip",
      verified: "github.comvercelgeist-font"
  name "Geist Mono"
  desc "Monospaced typeface designed to be used where code is represented"
  homepage "https:vercel.comfontmono"

  livecheck do
    url :url
    strategy :github_latest
  end

  font "Geist.MonoGeistMono-Black.otf"
  font "Geist.MonoGeistMono-Bold.otf"
  font "Geist.MonoGeistMono-Light.otf"
  font "Geist.MonoGeistMono-Medium.otf"
  font "Geist.MonoGeistMono-Regular.otf"
  font "Geist.MonoGeistMono-SemiBold.otf"
  font "Geist.MonoGeistMono-Thin.otf"
  font "Geist.MonoGeistMono-UltraBlack.otf"
  font "Geist.MonoGeistMono-UltraLight.otf"
  font "Geist.MonoGeistMonoVariableVF.ttf"

  # No zap stanza required
end