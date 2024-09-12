cask "equinox" do
  version "4.0"
  sha256 "ab2dfc4fa18f8fd808aa376bc4e20ea7c23e0eb8f3eb77387a25bef06728f2af"

  url "https:github.comrlxoneEquinoxreleasesdownloadv#{version}Equinox.dmg",
      verified: "github.comrlxoneEquinox"
  name "equinox"
  desc "Create dynamic wallpapers"
  homepage "https:equinoxmac.com"

  depends_on macos: ">= :mojave"

  app "Equinox.app"

  zap trash: [
    "~LibraryApplication Scriptscom.rlxone.equinox",
    "~LibraryContainerscom.rlxone.equinox",
  ]
end