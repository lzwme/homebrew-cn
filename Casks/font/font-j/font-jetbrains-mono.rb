cask "font-jetbrains-mono" do
  version "2.304"
  sha256 "6f6376c6ed2960ea8a963cd7387ec9d76e3f629125bc33d1fdcd7eb7012f7bbf"

  url "https:github.comJetBrainsJetBrainsMonoreleasesdownloadv#{version}JetBrainsMono-#{version}.zip",
      verified: "github.comJetBrainsJetBrainsMono"
  name "JetBrains Mono"
  homepage "https:www.jetbrains.comlpmono"

  livecheck do
    url :url
    strategy :gitHub_latest
  end

  no_autobump! because: :requires_manual_review

  font "fontsttfJetBrainsMono-Bold.ttf"
  font "fontsttfJetBrainsMono-BoldItalic.ttf"
  font "fontsttfJetBrainsMono-ExtraBold.ttf"
  font "fontsttfJetBrainsMono-ExtraBoldItalic.ttf"
  font "fontsttfJetBrainsMono-ExtraLight.ttf"
  font "fontsttfJetBrainsMono-ExtraLightItalic.ttf"
  font "fontsttfJetBrainsMono-Italic.ttf"
  font "fontsttfJetBrainsMono-Light.ttf"
  font "fontsttfJetBrainsMono-LightItalic.ttf"
  font "fontsttfJetBrainsMono-Medium.ttf"
  font "fontsttfJetBrainsMono-MediumItalic.ttf"
  font "fontsttfJetBrainsMono-Regular.ttf"
  font "fontsttfJetBrainsMono-SemiBold.ttf"
  font "fontsttfJetBrainsMono-SemiBoldItalic.ttf"
  font "fontsttfJetBrainsMono-Thin.ttf"
  font "fontsttfJetBrainsMono-ThinItalic.ttf"
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