cask "font-maple-mono-normal-nf" do
  version "7.5"
  sha256 "72591bd191ae67c3a1d6991d7bcba6bf4ea42d9fedf4e95afd51b44abb7dd1f2"

  url "https://ghfast.top/https://github.com/subframe7536/Maple-font/releases/download/v#{version}/MapleMonoNormal-NF-unhinted.zip",
      verified: "github.com/subframe7536/Maple-font/"
  name "Maple Mono Normal NF"
  homepage "https://font.subf.dev/en/"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMonoNormal-NF-Bold.ttf"
  font "MapleMonoNormal-NF-BoldItalic.ttf"
  font "MapleMonoNormal-NF-ExtraBold.ttf"
  font "MapleMonoNormal-NF-ExtraBoldItalic.ttf"
  font "MapleMonoNormal-NF-ExtraLight.ttf"
  font "MapleMonoNormal-NF-ExtraLightItalic.ttf"
  font "MapleMonoNormal-NF-Italic.ttf"
  font "MapleMonoNormal-NF-Light.ttf"
  font "MapleMonoNormal-NF-LightItalic.ttf"
  font "MapleMonoNormal-NF-Medium.ttf"
  font "MapleMonoNormal-NF-MediumItalic.ttf"
  font "MapleMonoNormal-NF-Regular.ttf"
  font "MapleMonoNormal-NF-SemiBold.ttf"
  font "MapleMonoNormal-NF-SemiBoldItalic.ttf"
  font "MapleMonoNormal-NF-Thin.ttf"
  font "MapleMonoNormal-NF-ThinItalic.ttf"

  # No zap stanza required
end