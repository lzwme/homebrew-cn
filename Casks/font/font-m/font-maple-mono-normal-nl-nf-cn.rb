cask "font-maple-mono-normal-nl-nf-cn" do
  version "7.6"
  sha256 "eb140f10094c8c415bd016934aa0bfe107c2719603f2e5183033a019516a76bb"

  url "https://ghfast.top/https://github.com/subframe7536/Maple-font/releases/download/v#{version}/MapleMonoNormalNL-NF-CN-unhinted.zip",
      verified: "github.com/subframe7536/Maple-font/"
  name "Maple Mono Normal NL NF CN"
  homepage "https://font.subf.dev/en/"

  livecheck do
    cask "font-maple-mono"
  end

  font "MapleMonoNormalNL-NF-CN-Bold.ttf"
  font "MapleMonoNormalNL-NF-CN-BoldItalic.ttf"
  font "MapleMonoNormalNL-NF-CN-ExtraBold.ttf"
  font "MapleMonoNormalNL-NF-CN-ExtraBoldItalic.ttf"
  font "MapleMonoNormalNL-NF-CN-ExtraLight.ttf"
  font "MapleMonoNormalNL-NF-CN-ExtraLightItalic.ttf"
  font "MapleMonoNormalNL-NF-CN-Italic.ttf"
  font "MapleMonoNormalNL-NF-CN-Light.ttf"
  font "MapleMonoNormalNL-NF-CN-LightItalic.ttf"
  font "MapleMonoNormalNL-NF-CN-Medium.ttf"
  font "MapleMonoNormalNL-NF-CN-MediumItalic.ttf"
  font "MapleMonoNormalNL-NF-CN-Regular.ttf"
  font "MapleMonoNormalNL-NF-CN-SemiBold.ttf"
  font "MapleMonoNormalNL-NF-CN-SemiBoldItalic.ttf"
  font "MapleMonoNormalNL-NF-CN-Thin.ttf"
  font "MapleMonoNormalNL-NF-CN-ThinItalic.ttf"

  # No zap stanza required
end