cask "lightgallery" do
  version "0.1.1"
  sha256 "5650328b475391c5c16cbc616096fe70a8ec7c8e5f19329fd2bd660d7ac104cd"

  url "https:github.comsachinchoolurlightgallery-desktopreleasesdownload#{version}lightgallery_#{version}.dmg-mac.zip",
      verified: "github.comsachinchoolurlightgallery-desktop"
  name "lightgallery"
  homepage "https:sachinchoolur.github.iolightgallery-desktop"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-18", because: :unmaintained

  app "lightgallery.app"

  zap trash: [
    "~LibraryApplication SupportLightgallery",
    "~LibraryCachesLightgallery",
    "~LibraryPreferenceslightgallery-desktop.plist",
  ]

  caveats do
    requires_rosetta
  end
end