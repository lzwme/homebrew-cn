cask "specter" do
  version "2.0.2"
  sha256 "20bfd7c4daea70499ab3e04831fb006867cb21c7299aad282ca566b35cd4e7fd"

  url "https:github.comcryptoadvancespecter-desktopreleasesdownloadv#{version}Specter-v#{version}.dmg",
      verified: "github.comcryptoadvancespecter-desktop"
  name "Specter"
  desc "Desktop GUI for Bitcoin Core optimised to work with hardware wallets"
  homepage "https:specter.solutions"

  livecheck do
    url "https:github.comcryptoadvancespecter-desktopreleases"
    regex(%r{v?(\d+(?:\.\d+)+)Specter.*?\.dmg}i)
    strategy :page_match
  end

  depends_on macos: ">= :catalina"

  app "Specter.app"

  zap trash: [
    "~LibraryApplication Supportspecter-desktop",
    "~LibraryPreferencessolutions.specter.desktop.plist",
    "~LibrarySaved Application Statesolutions.specter.desktop.savedState",
  ]
end