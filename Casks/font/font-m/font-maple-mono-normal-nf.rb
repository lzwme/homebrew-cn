cask "font-maple-mono-normal-nf" do
  version "7.2"
  sha256 "d8b96b11823dd861d12022df61b525f54f846dd01b0a38994970fbcf9bd10b8c"

  url "https:github.comsubframe7536Maple-fontreleasesdownloadv#{version}MapleMonoNormal-NF-unhinted.zip",
      verified: "github.comsubframe7536Maple-font"
  name "Maple Mono Normal NF"
  homepage "https:font.subf.deven"

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