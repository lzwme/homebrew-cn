cask "lightgallery" do
  version "0.1.1"
  sha256 "5650328b475391c5c16cbc616096fe70a8ec7c8e5f19329fd2bd660d7ac104cd"

  url "https:github.comsachinchoolurlightgallery-desktopreleasesdownload#{version}lightgallery_#{version}.dmg-mac.zip",
      verified: "github.comsachinchoolurlightgallery-desktop"
  name "lightgallery"
  homepage "https:sachinchoolur.github.iolightgallery-desktop"

  app "lightgallery.app"

  zap trash: [
    "~LibraryApplication SupportLightgallery",
    "~LibraryCachesLightgallery",
    "~LibraryPreferenceslightgallery-desktop.plist",
  ]
end