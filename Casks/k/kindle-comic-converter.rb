cask "kindle-comic-converter" do
  version "5.6.5"
  sha256 "c32d71b35f1d8f34a8706a79cda2766b24b5f7ad5cab10253ebf28e7464972a6"

  url "https:github.comciromattiakccreleasesdownloadv#{version}KindleComicConverter_osx_#{version}.dmg",
      verified: "github.comciromattiakcc"
  name "Kindle Comic Converter"
  name "KCC"
  desc "Comic and manga converter for ebook readers"
  homepage "https:kcc.iosphe.re"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :mojave"

  app "Kindle Comic Converter.app"

  zap trash: "~LibraryPreferencescom.kindlecomicconverter.KindleComicConverter.plist"

  caveats do
    requires_rosetta
  end
end