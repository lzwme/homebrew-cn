cask "thorium" do
  version "2.4.1"
  sha256 "8308daa5b0894556baa10c79ce3dbdd7624bd727635d3963d11c17140cdd38db"

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