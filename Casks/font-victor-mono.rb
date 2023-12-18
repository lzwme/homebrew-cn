cask "font-victor-mono" do
  version "1.5.5"
  sha256 :no_check

  url "https:rubjo.github.iovictor-monoVictorMonoAll.zip"
  name "Victor Mono"
  desc "Monospaced font with cursive italics and programming symbol ligatures"
  homepage "https:rubjo.github.iovictor-mono"

  livecheck do
    url "https:github.comrubjovictor-monoreleases"
  end

  font "OTFVictorMono-Thin.otf"
  font "OTFVictorMono-ExtraLight.otf"
  font "OTFVictorMono-Light.otf"
  font "OTFVictorMono-Regular.otf"
  font "OTFVictorMono-Medium.otf"
  font "OTFVictorMono-SemiBold.otf"
  font "OTFVictorMono-Bold.otf"
  font "OTFVictorMono-ThinOblique.otf"
  font "OTFVictorMono-ExtraLightOblique.otf"
  font "OTFVictorMono-LightOblique.otf"
  font "OTFVictorMono-Oblique.otf"
  font "OTFVictorMono-MediumOblique.otf"
  font "OTFVictorMono-SemiBoldOblique.otf"
  font "OTFVictorMono-BoldOblique.otf"
  font "OTFVictorMono-ThinItalic.otf"
  font "OTFVictorMono-ExtraLightItalic.otf"
  font "OTFVictorMono-LightItalic.otf"
  font "OTFVictorMono-Italic.otf"
  font "OTFVictorMono-MediumItalic.otf"
  font "OTFVictorMono-SemiBoldItalic.otf"
  font "OTFVictorMono-BoldItalic.otf"

  # No zap stanza required
end