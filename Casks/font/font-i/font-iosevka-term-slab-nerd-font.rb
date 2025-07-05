cask "font-iosevka-term-slab-nerd-font" do
  version "3.4.0"
  sha256 "f55d44e1f9b9c7f0a1bf9652fb87abf3d0a8f1d32c6e50a5a7554c33d1633497"

  url "https://ghfast.top/https://github.com/ryanoasis/nerd-fonts/releases/download/v#{version}/IosevkaTermSlab.zip"
  name "IosevkaTermSlab Nerd Font (Iosevka Term Slab)"
  homepage "https://github.com/ryanoasis/nerd-fonts"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  font "IosevkaTermSlabNerdFont-Bold.ttf"
  font "IosevkaTermSlabNerdFont-BoldItalic.ttf"
  font "IosevkaTermSlabNerdFont-BoldOblique.ttf"
  font "IosevkaTermSlabNerdFont-ExtraBold.ttf"
  font "IosevkaTermSlabNerdFont-ExtraBoldItalic.ttf"
  font "IosevkaTermSlabNerdFont-ExtraBoldOblique.ttf"
  font "IosevkaTermSlabNerdFont-Italic.ttf"
  font "IosevkaTermSlabNerdFont-Light.ttf"
  font "IosevkaTermSlabNerdFont-LightItalic.ttf"
  font "IosevkaTermSlabNerdFont-LightOblique.ttf"
  font "IosevkaTermSlabNerdFont-Medium.ttf"
  font "IosevkaTermSlabNerdFont-MediumItalic.ttf"
  font "IosevkaTermSlabNerdFont-MediumOblique.ttf"
  font "IosevkaTermSlabNerdFont-Oblique.ttf"
  font "IosevkaTermSlabNerdFont-Regular.ttf"
  font "IosevkaTermSlabNerdFontMono-Bold.ttf"
  font "IosevkaTermSlabNerdFontMono-BoldItalic.ttf"
  font "IosevkaTermSlabNerdFontMono-BoldOblique.ttf"
  font "IosevkaTermSlabNerdFontMono-ExtraBold.ttf"
  font "IosevkaTermSlabNerdFontMono-ExtraBoldItalic.ttf"
  font "IosevkaTermSlabNerdFontMono-ExtraBoldOblique.ttf"
  font "IosevkaTermSlabNerdFontMono-Italic.ttf"
  font "IosevkaTermSlabNerdFontMono-Light.ttf"
  font "IosevkaTermSlabNerdFontMono-LightItalic.ttf"
  font "IosevkaTermSlabNerdFontMono-LightOblique.ttf"
  font "IosevkaTermSlabNerdFontMono-Medium.ttf"
  font "IosevkaTermSlabNerdFontMono-MediumItalic.ttf"
  font "IosevkaTermSlabNerdFontMono-MediumOblique.ttf"
  font "IosevkaTermSlabNerdFontMono-Oblique.ttf"
  font "IosevkaTermSlabNerdFontMono-Regular.ttf"
  font "IosevkaTermSlabNerdFontPropo-Bold.ttf"
  font "IosevkaTermSlabNerdFontPropo-BoldItalic.ttf"
  font "IosevkaTermSlabNerdFontPropo-BoldOblique.ttf"
  font "IosevkaTermSlabNerdFontPropo-ExtraBold.ttf"
  font "IosevkaTermSlabNerdFontPropo-ExtraBoldItalic.ttf"
  font "IosevkaTermSlabNerdFontPropo-ExtraBoldOblique.ttf"
  font "IosevkaTermSlabNerdFontPropo-Italic.ttf"
  font "IosevkaTermSlabNerdFontPropo-Light.ttf"
  font "IosevkaTermSlabNerdFontPropo-LightItalic.ttf"
  font "IosevkaTermSlabNerdFontPropo-LightOblique.ttf"
  font "IosevkaTermSlabNerdFontPropo-Medium.ttf"
  font "IosevkaTermSlabNerdFontPropo-MediumItalic.ttf"
  font "IosevkaTermSlabNerdFontPropo-MediumOblique.ttf"
  font "IosevkaTermSlabNerdFontPropo-Oblique.ttf"
  font "IosevkaTermSlabNerdFontPropo-Regular.ttf"

  # No zap stanza required
end