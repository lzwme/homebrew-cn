cask "thorium" do
  version "2.4.0"
  sha256 "353ea171a32953398d9fff85aa6e4d8b8b21e1552aef5b10528d160af6bf335b"

  url "https:github.comedrlabthorium-readerreleasesdownloadv#{version}Thorium-#{version}.dmg",
      verified: "github.comedrlabthorium-reader"
  name "Thorium Reader"
  desc "Epub reader"
  homepage "https:www.edrlab.orgsoftwarethorium-reader"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Thorium.app"

  zap trash: [
    "~LibraryApplication SupportEDRLab.ThoriumReader",
    "~LibraryPreferencesio.github.edrlab.thorium.plist",
  ]
end