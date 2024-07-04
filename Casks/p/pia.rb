cask "pia" do
  version "3.0.3"
  sha256 "696dafca5d4a4472eca0c1ded044a3ef3448d767e0a8a65c239ec5c415187964"

  url "https:github.comLINCnilpiareleasesdownloadv#{version}pia-#{version}.dmg"
  name "Pia"
  desc "Privacy Impact Assessment Tool"
  homepage "https:github.comLINCnilpia"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "pia.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.atnos.pia.sfl*",
    "~LibraryApplication SupportCrashReporterpia_*.plist",
    "~LibraryApplication Supportpia",
    "~LibraryLogspia",
    "~LibraryPreferencescom.atnos.pia.plist",
    "~LibrarySaved Application Statecom.atnos.pia.savedState",
  ]

  caveats do
    requires_rosetta
  end
end