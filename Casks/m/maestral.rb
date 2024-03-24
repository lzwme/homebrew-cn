cask "maestral" do
  version "1.9.1"
  sha256 "a4fb3e6e81ea59781aaf6d8192557314847ddbcc8793dda392f07ecae961e078"

  url "https:github.comSamSchottmaestralreleasesdownloadv#{version}Maestral-#{version}.dmg",
      verified: "github.comSamSchottmaestral"
  name "Maestral"
  desc "Open-source Dropbox client"
  homepage "https:maestral.app"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "Maestral.app"
  binary "#{appdir}Maestral.appContentsMacOSmaestral-cli", target: "maestral"

  uninstall quit: "com.samschott.maestral"

  zap trash: [
    "~LibraryApplication Supportmaestral",
    "~LibraryLaunchAgentscom.samschott.maestral.maestral.plist",
    "~LibraryLogsmaestral",
    "~LibraryPreferencescom.samschott.maestral.plist",
  ]
end