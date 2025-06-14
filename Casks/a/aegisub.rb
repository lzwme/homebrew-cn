cask "aegisub" do
  version "3.4.2"
  sha256 "cbbfd3276e0414b540f6b1bc12a69abd6b8a96b0a452de3b08c290d553754ad3"

  url "https:github.comTypesettingToolsAegisubreleasesdownloadv#{version}Aegisub-#{version}.dmg",
      verified: "github.comTypesettingToolsAegisub"
  name "Aegisub"
  desc "Create and modify subtitles"
  homepage "https:aegisub.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "Aegisub.app"

  uninstall quit: "com.aegisub.aegisub"

  zap trash: [
    "~LibraryApplication SupportAegisub",
    "~LibraryPreferencescom.aegisub.aegisub.plist",
    "~LibrarySaved Application Statecom.aegisub.aegisub.savedState",
  ]

  caveats do
    requires_rosetta
  end
end