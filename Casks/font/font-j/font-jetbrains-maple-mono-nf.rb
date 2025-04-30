cask "font-jetbrains-maple-mono-nf" do
  version "1.2304.72"
  sha256 "5276cf3e87eceb6f71e10e373e5eed62692dbd2b891f2641128bab400d88d3cd"

  url "https:github.comSpaceTimeeFusion-JetBrainsMapleMonoreleasesdownload#{version}JetBrainsMapleMono-NF-XX-XX.zip"
  name "JetBrains Maple Mono NF"
  homepage "https:github.comSpaceTimeeFusion-JetBrainsMapleMono"

  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "font-jetbrains-maple-mono"

  font "JetBrainsMapleMono-Bold.ttf"
  font "JetBrainsMapleMono-BoldItalic.ttf"
  font "JetBrainsMapleMono-ExtraBold.ttf"
  font "JetBrainsMapleMono-ExtraBoldItalic.ttf"
  font "JetBrainsMapleMono-ExtraLight.ttf"
  font "JetBrainsMapleMono-ExtraLightItalic.ttf"
  font "JetBrainsMapleMono-Italic.ttf"
  font "JetBrainsMapleMono-Light.ttf"
  font "JetBrainsMapleMono-LightItalic.ttf"
  font "JetBrainsMapleMono-Medium.ttf"
  font "JetBrainsMapleMono-MediumItalic.ttf"
  font "JetBrainsMapleMono-Regular.ttf"
  font "JetBrainsMapleMono-SemiBold.ttf"
  font "JetBrainsMapleMono-SemiBoldItalic.ttf"
  font "JetBrainsMapleMono-Thin.ttf"
  font "JetBrainsMapleMono-ThinItalic.ttf"

  # No zap stanza required
end