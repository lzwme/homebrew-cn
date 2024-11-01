cask "specter" do
  version "2.0.5"
  sha256 "2419d08e0cc32c6c1e8d7f09af90e4e867d786bc51ee238f62ff741785caccc3"

  url "https:github.comcryptoadvancespecter-desktopreleasesdownloadv#{version}Specter-v#{version}.dmg",
      verified: "github.comcryptoadvancespecter-desktop"
  name "Specter"
  desc "Desktop GUI for Bitcoin Core optimised to work with hardware wallets"
  homepage "https:specter.solutions"

  # Upstream doesn't reliably mark unstable versions as pre-release on GitHub.
  # We check the upstream download page, which links to the latest stable files
  # on GitHub.
  livecheck do
    url "https:specter.solutionsdownloads"
    regex(href=.*?Specter[._-]v?(\d+(?:\.\d+)+)\.dmgi)
  end

  depends_on macos: ">= :catalina"

  app "Specter.app"

  zap trash: [
    "~LibraryApplication Supportspecter-desktop",
    "~LibraryPreferencessolutions.specter.desktop.plist",
    "~LibrarySaved Application Statesolutions.specter.desktop.savedState",
  ]
end