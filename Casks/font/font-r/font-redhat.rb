cask "font-redhat" do
  version "4.0.3"
  sha256 "95e9eaa3bbbb343d0d4bc519d18a216651c73b0ab191ab5532a3cb370120b2b2"

  url "https:github.comRedHatOfficialRedHatFontarchive#{version}.tar.gz"
  name "Red Hat"
  homepage "https:github.comRedHatOfficialRedHatFont"

  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-Black.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-BlackItalic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-Bold.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-BoldItalic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-Italic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-Light.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-LightItalic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-Medium.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-MediumItalic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatDisplay-Regular.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-Bold.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-BoldItalic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-Italic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-Light.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-LightItalic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-Medium.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-MediumItalic.otf"
  font "RedHatFont-#{version}fontsproportionalstaticotfRedHatText-Regular.otf"
  font "RedHatFont-#{version}fontsproportionalRedHatDisplayVF-Italic[wght].ttf"
  font "RedHatFont-#{version}fontsproportionalRedHatDisplayVF[wght].ttf"
  font "RedHatFont-#{version}fontsproportionalRedHatTextVF-Italic[wght].ttf"
  font "RedHatFont-#{version}fontsproportionalRedHatTextVF[wght].ttf"

  # No zap stanza required
end