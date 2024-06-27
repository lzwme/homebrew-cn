cask "thorium" do
  version "3.0.0"
  sha256 "340c04e31e750de699a838aca643b4c2c966751d7ad0627cd33f531e1b596d65"

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