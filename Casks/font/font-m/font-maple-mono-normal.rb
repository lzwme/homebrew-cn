cask "font-maple-mono-normal" do
  version "7.2"
  sha256 "984249ff2e5a9a1301b7e32ba1250cb9a4ea1a0dcb51e6138809ffbc031fcb95"

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