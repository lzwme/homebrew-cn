cask "remix-ide" do
  version "1.3.6"
  sha256 "a4a0d81e06f99f5721864afbf587b273a61d19b2d6e690a015dff2bf681039a4"

  url "https:github.comethereumremix-desktopreleasesdownloadv#{version}Remix-IDE-#{version}.dmg",
      verified: "github.comethereumremix-desktop"
  name "Remix IDE desktop"
  desc "Desktop version of Remix web IDE used for Ethereum smart contract development"
  homepage "https:remix-project.org"

  no_autobump! because: :requires_manual_review

  deprecate! date: "2024-07-28", because: :discontinued

  app "Remix IDE.app"

  zap trash: [
    "~LibraryPreferencesorg.ethereum.remix-ide.plist",
    "~LibrarySaved Application Stateorg.ethereum.remix-ide.savedState",
  ]

  caveats do
    requires_rosetta
  end
end