cask "equinox" do
  version "2.0"
  sha256 "6f10fecbc09619a80b78980cef476d78e55c7ef02cac07e75816a7c7be8113b1"

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