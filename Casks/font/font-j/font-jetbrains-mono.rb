cask "font-jetbrains-mono" do
  version "2.304"
  sha256 "6f6376c6ed2960ea8a963cd7387ec9d76e3f629125bc33d1fdcd7eb7012f7bbf"

  url "https://ghfast.top/https://github.com/JetBrains/JetBrainsMono/releases/download/v#{version}/JetBrainsMono-#{version}.zip",
      verified: "github.com/JetBrains/JetBrainsMono/"
  name "JetBrains Mono"
  homepage "https://www.jetbrains.com/lp/mono"

  livecheck do
    url :url
    strategy :gitHub_latest
  end

  no_autobump! because: :requires_manual_review

  font "fonts/ttf/JetBrainsMono-Bold.ttf"
  font "fonts/ttf/JetBrainsMono-BoldItalic.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraBold.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraBoldItalic.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraLight.ttf"
  font "fonts/ttf/JetBrainsMono-ExtraLightItalic.ttf"
  font "fonts/ttf/JetBrainsMono-Italic.ttf"
  font "fonts/ttf/JetBrainsMono-Light.ttf"
  font "fonts/ttf/JetBrainsMono-LightItalic.ttf"
  font "fonts/ttf/JetBrainsMono-Medium.ttf"
  font "fonts/ttf/JetBrainsMono-MediumItalic.ttf"
  font "fonts/ttf/JetBrainsMono-Regular.ttf"
  font "fonts/ttf/JetBrainsMono-SemiBold.ttf"
  font "fonts/ttf/JetBrainsMono-SemiBoldItalic.ttf"
  font "fonts/ttf/JetBrainsMono-Thin.ttf"
  font "fonts/ttf/JetBrainsMono-ThinItalic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-Bold.ttf"
  font "fonts/ttf/JetBrainsMonoNL-BoldItalic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-ExtraBold.ttf"
  font "fonts/ttf/JetBrainsMonoNL-ExtraBoldItalic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-ExtraLight.ttf"
  font "fonts/ttf/JetBrainsMonoNL-ExtraLightItalic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-Italic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-Light.ttf"
  font "fonts/ttf/JetBrainsMonoNL-LightItalic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-Medium.ttf"
  font "fonts/ttf/JetBrainsMonoNL-MediumItalic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-Regular.ttf"
  font "fonts/ttf/JetBrainsMonoNL-SemiBold.ttf"
  font "fonts/ttf/JetBrainsMonoNL-SemiBoldItalic.ttf"
  font "fonts/ttf/JetBrainsMonoNL-Thin.ttf"
  font "fonts/ttf/JetBrainsMonoNL-ThinItalic.ttf"
  font "fonts/variable/JetBrainsMono-Italic[wght].ttf"
  font "fonts/variable/JetBrainsMono[wght].ttf"

  # No zap stanza required
end