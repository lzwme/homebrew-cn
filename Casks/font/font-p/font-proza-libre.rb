cask "font-proza-libre" do
  version "1.0"
  sha256 "c6d975321ef7853769a68fbb290c3f0b0b72ca175a2bbd2a33b1bdf2e1db5490"

  url "https:github.comjasperdewaardProza-Librearchiverefstags#{version}.tar.gz"
  name "Proza Libre"
  homepage "https:github.comjasperdewaardProza-Libre"

  font "Proza-Libre-#{version}FontsProzaLibre-Bold.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-BoldItalic.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-ExtraBold.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-ExtraBoldItalic.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-Italic.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-Medium.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-MediumItalic.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-Regular.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-SemiBold.ttf"
  font "Proza-Libre-#{version}FontsProzaLibre-SemiBoldItalic.ttf"

  # No zap stanza required
end