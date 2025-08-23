cask "font-maple-mono-normal-nf-cn" do
  version "7.6"
  sha256 "b9124425591ca00c8af3957bf3c514dbd47d947f55bb0f516ecaeb4843b374c5"

  url "https://ghfast.top/https://github.com/subframe7536/Maple-font/releases/download/v#{version}/MapleMonoNormal-NF-CN-unhinted.zip",
      verified: "github.com/subframe7536/Maple-font/"
  name "Maple Mono Normal NF CN"
  homepage "https://font.subf.dev/en/"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMonoNormal-NF-CN-Bold.ttf"
  font "MapleMonoNormal-NF-CN-BoldItalic.ttf"
  font "MapleMonoNormal-NF-CN-ExtraBold.ttf"
  font "MapleMonoNormal-NF-CN-ExtraBoldItalic.ttf"
  font "MapleMonoNormal-NF-CN-ExtraLight.ttf"
  font "MapleMonoNormal-NF-CN-ExtraLightItalic.ttf"
  font "MapleMonoNormal-NF-CN-Italic.ttf"
  font "MapleMonoNormal-NF-CN-Light.ttf"
  font "MapleMonoNormal-NF-CN-LightItalic.ttf"
  font "MapleMonoNormal-NF-CN-Medium.ttf"
  font "MapleMonoNormal-NF-CN-MediumItalic.ttf"
  font "MapleMonoNormal-NF-CN-Regular.ttf"
  font "MapleMonoNormal-NF-CN-SemiBold.ttf"
  font "MapleMonoNormal-NF-CN-SemiBoldItalic.ttf"
  font "MapleMonoNormal-NF-CN-Thin.ttf"
  font "MapleMonoNormal-NF-CN-ThinItalic.ttf"

  # No zap stanza required
end