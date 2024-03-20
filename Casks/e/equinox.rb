cask "equinox" do
  version "3.0"
  sha256 "b35388a43fe481e8acd391c0d644cb4c7be77e48f7ca049ddb8ef70dee6326de"

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