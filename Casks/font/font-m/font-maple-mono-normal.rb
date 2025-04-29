cask "font-maple-mono-normal" do
  version "7.1"
  sha256 "1542eef0b6855be45c5223b91d58f67b8be17dca6182f9b2453fe2434ff141cf"

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