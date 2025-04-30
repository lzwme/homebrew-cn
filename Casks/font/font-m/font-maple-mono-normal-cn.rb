cask "font-maple-mono-normal-cn" do
  version "7.2"
  sha256 "05144849f036d4442f3549421b0362541919a43005fa2095f7d2ec609b2ebfd4"

  url "https:github.comsubframe7536Maple-fontreleasesdownloadv#{version}MapleMonoNormal-CN-unhinted.zip",
      verified: "github.comsubframe7536Maple-font"
  name "Maple Mono Normal CN"
  homepage "https:font.subf.deven"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMonoNormal-CN-Bold.ttf"
  font "MapleMonoNormal-CN-BoldItalic.ttf"
  font "MapleMonoNormal-CN-ExtraBold.ttf"
  font "MapleMonoNormal-CN-ExtraBoldItalic.ttf"
  font "MapleMonoNormal-CN-ExtraLight.ttf"
  font "MapleMonoNormal-CN-ExtraLightItalic.ttf"
  font "MapleMonoNormal-CN-Italic.ttf"
  font "MapleMonoNormal-CN-Light.ttf"
  font "MapleMonoNormal-CN-LightItalic.ttf"
  font "MapleMonoNormal-CN-Medium.ttf"
  font "MapleMonoNormal-CN-MediumItalic.ttf"
  font "MapleMonoNormal-CN-Regular.ttf"
  font "MapleMonoNormal-CN-SemiBold.ttf"
  font "MapleMonoNormal-CN-SemiBoldItalic.ttf"
  font "MapleMonoNormal-CN-Thin.ttf"
  font "MapleMonoNormal-CN-ThinItalic.ttf"

  # No zap stanza required
end