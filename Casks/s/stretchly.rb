cask "stretchly" do
  arch arm: "-arm64"

  version "1.16.0"
  sha256 arm:   "eaf7204b77d7a2cd3fa3ff3e8e54fdf542440b33e035cef4799d31b35433eb5e",
         intel: "c2a3766833fb3a249af1ea939db18545be069254bffe6357bd83f725cadc4967"

  url "https:github.comhovancikstretchlyreleasesdownloadv#{version}stretchly-#{version}#{arch}.dmg",
      verified: "github.comhovancikstretchly"
  name "Stretchly"
  desc "Break time reminder app"
  homepage "https:hovancik.netstretchly"

  depends_on macos: ">= :catalina"

  app "Stretchly.app"

  uninstall quit: "net.hovancik.stretchly"

  zap trash: [
    "~LibraryApplication SupportStretchly",
    "~LibraryLogsStretchly",
    "~LibraryPreferencesnet.hovancik.stretchly.plist",
  ]

  caveats <<~EOS
    This application is not signed. For details see:

    https:github.comhovancikstretchly#application-signing
  EOS
end