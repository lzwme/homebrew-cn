cask "font-jetbrains-mono" do
  version "2.304"
  sha256 "6f6376c6ed2960ea8a963cd7387ec9d76e3f629125bc33d1fdcd7eb7012f7bbf"

  url "https:github.comJetBrainsJetBrainsMonoreleasesdownloadv#{version}JetBrainsMono-#{version}.zip",
      verified: "github.comJetBrainsJetBrainsMono"
  name "JetBrains Mono"
  desc "Typeface made for developers"
  homepage "https:www.jetbrains.comlpmono"

  livecheck do
    url "https:github.comJetBrainsJetBrainsMono"
    strategy :gitHub_latest
  end

  font "fontsttfJetBrainsMonoNL-Bold.ttf"
  font "fontsttfJetBrainsMonoNL-BoldItalic.ttf"
  font "fontsttfJetBrainsMonoNL-ExtraBold.ttf"
  font "fontsttfJetBrainsMonoNL-ExtraBoldItalic.ttf"
  font "fontsttfJetBrainsMonoNL-ExtraLight.ttf"
  font "fontsttfJetBrainsMonoNL-ExtraLightItalic.ttf"
  font "fontsttfJetBrainsMonoNL-Italic.ttf"
  font "fontsttfJetBrainsMonoNL-Light.ttf"
  font "fontsttfJetBrainsMonoNL-LightItalic.ttf"
  font "fontsttfJetBrainsMonoNL-Medium.ttf"
  font "fontsttfJetBrainsMonoNL-MediumItalic.ttf"
  font "fontsttfJetBrainsMonoNL-Regular.ttf"
  font "fontsttfJetBrainsMonoNL-SemiBold.ttf"
  font "fontsttfJetBrainsMonoNL-SemiBoldItalic.ttf"
  font "fontsttfJetBrainsMonoNL-Thin.ttf"
  font "fontsttfJetBrainsMonoNL-ThinItalic.ttf"
  font "fontsvariableJetBrainsMono-Italic[wght].ttf"
  font "fontsvariableJetBrainsMono[wght].ttf"

  # No zap stanza required
end