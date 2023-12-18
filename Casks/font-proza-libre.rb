cask "font-proza-libre" do
  version "1.0"
  sha256 "cbd3bb929d905330ad9e2d4b2efc3edf5c351eb5b4a238bd87367e74836fa9c9"

  url "https:github.comjasperdewaardProza-Librearchive#{version}.zip"
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