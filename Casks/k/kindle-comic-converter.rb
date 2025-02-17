cask "kindle-comic-converter" do
  arch arm: "arm", intel: "i386"

  version "7.2.0"
  sha256 arm:   "562618ac1a63f426958dbf8c6d1699ef291631cd50c4fc3d9266f206c30a1fb8",
         intel: "90d22e09adf5eaf042e88c9911884c3fa22be2e91be9607d9de519f2bdef1cd7"

  url "https:github.comciromattiakccreleasesdownloadv#{version}kcc_macos_#{arch}_#{version}.dmg",
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
end