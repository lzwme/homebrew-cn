cask "ballast" do
  version "2.0.0"
  sha256 "ec96d590fd9dbe38fe50de006160d4ff2bd10187c4b011c1f5c5ea741044904a"

  url "https:github.comjamsinclairballastreleasesdownloadv#{version}ballast-v#{version}.zip",
      verified: "github.comjamsinclairballast"
  name "ballast"
  desc "Status Bar app to keep the audio balance from drifting"
  homepage "https:jamsinclair.nzballast"

  depends_on macos: ">= :sierra"

  app "ballast.app"

  uninstall launchctl: "nz.jamsinclair.ballast-LaunchAtLoginHelper",
            quit:      "nz.jamsinclair.ballast"

  zap trash: [
    "~LibraryApplication Scriptsnz.jamsinclair.ballast",
    "~LibraryApplication Scriptsnz.jamsinclair.ballast-LaunchAtLoginHelper",
    "~LibraryContainersnz.jamsinclair.ballast",
    "~LibraryContainersnz.jamsinclair.ballast-LaunchAtLoginHelper",
    "~LibraryPreferencesnz.jamsinclair.ballast.plist",
  ]
end