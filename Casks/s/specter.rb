cask "specter" do
  version "2.0.4"
  sha256 "832e2f284c04fb631d1a775fe4fa4d40f1cd666ebb64d06bf92aa7962130771e"

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