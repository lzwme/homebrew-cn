cask "qlfits" do
  version "3.2.2"
  sha256 "95320c8fcdf02681d592122ef75ab8e1b0ee8d6f394760b3c25f8485a3e6c130"

  url "https:github.comonekiloparsecQLFitsreleasesdownload#{version}QLFits#{version.major}.qlgenerator.zip"
  name "QLFits"
  desc "QuickLook plugin to view FITS files"
  homepage "https:github.comonekiloparsecQLFits"

  qlplugin "QLFits#{version.major}.qlgenerator"

  zap trash: "~LibraryPreferencescom.softtenebraslux.qlfitsgenerator.plist"
end