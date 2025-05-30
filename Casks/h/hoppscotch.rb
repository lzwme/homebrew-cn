cask "hoppscotch" do
  arch arm: "aarch64", intel: "x64"

  version "25.5.1-0"
  sha256 arm:   "d37592738fee75a4a173db5eed7bf4f600a032ff62dbf5af2b9e66a63e002b99",
         intel: "d43fd95be2b16e626db7adae40e75967088a93eeabd6186f8b07bb099c5a5e7b"

  url "https:github.comhoppscotchreleasesreleasesdownloadv#{version}Hoppscotch_mac_#{arch}.dmg",
      verified: "github.comhoppscotchreleases"
  name "Hoppscotch"
  desc "Open source API development ecosystem"
  homepage "https:hoppscotch.com"

  depends_on macos: ">= :high_sierra"

  app "Hoppscotch.app"

  zap trash: [
    "~LibraryApplication Supportio.hoppscotch.desktop",
    "~LibraryCachesio.hoppscotch.desktop",
    "~LibrarySaved Application Stateio.hoppscotch.desktop.savedState",
    "~LibraryWebKitio.hoppscotch.desktop",
  ]
end