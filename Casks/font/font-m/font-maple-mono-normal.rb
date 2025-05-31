cask "font-maple-mono-normal" do
  version "7.3"
  sha256 "7140bdbadcb48ae7729b5af72cd47e858a1621ebf22225c2d0c6cad44a65e92e"

  url "https:github.comsubframe7536Maple-fontreleasesdownloadv#{version}MapleMonoNormal-TTF.zip",
      verified: "github.comsubframe7536Maple-font"
  name "Maple Mono Normal"
  homepage "https:font.subf.deven"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMonoNormal-Bold.ttf"
  font "MapleMonoNormal-BoldItalic.ttf"
  font "MapleMonoNormal-ExtraBold.ttf"
  font "MapleMonoNormal-ExtraBoldItalic.ttf"
  font "MapleMonoNormal-ExtraLight.ttf"
  font "MapleMonoNormal-ExtraLightItalic.ttf"
  font "MapleMonoNormal-Italic.ttf"
  font "MapleMonoNormal-Light.ttf"
  font "MapleMonoNormal-LightItalic.ttf"
  font "MapleMonoNormal-Medium.ttf"
  font "MapleMonoNormal-MediumItalic.ttf"
  font "MapleMonoNormal-Regular.ttf"
  font "MapleMonoNormal-SemiBold.ttf"
  font "MapleMonoNormal-SemiBoldItalic.ttf"
  font "MapleMonoNormal-Thin.ttf"
  font "MapleMonoNormal-ThinItalic.ttf"

  # No zap stanza required
end