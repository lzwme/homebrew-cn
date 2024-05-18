cask "specter" do
  version "2.0.3"
  sha256 "e86575600c76274a2ab111ecaca6ab85697147800b954a692c74d6cc19e1d639"

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