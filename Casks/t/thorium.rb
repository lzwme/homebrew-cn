cask "thorium" do
  version "2.3.0"
  sha256 "87680fb4bdf63f2dcaed9507f9af10a8e8f8f20412fcdc455f611eefc99458f6"

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