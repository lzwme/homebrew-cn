cask "aegisub" do
  version "3.2.2"
  sha256 "d71fa46f074a2d5a252f30779e0b8d913d5157258f5d9fc333411f8c9493f42b"

  url "https:github.comAegisubAegisubreleasesdownloadv#{version}Aegisub-#{version}.dmg"
  name "Aegisub"
  desc "Create and modify subtitles"
  homepage "https:github.comAegisubAegisub"

  livecheck do
    url :url
    strategy :github_latest
  end

  app "Aegisub.app"

  uninstall quit: "com.aegisub.aegisub"

  zap trash: [
    "~LibraryApplication SupportAegisub",
    "~LibraryPreferencescom.aegisub.aegisub.plist",
    "~LibrarySaved Application Statecom.aegisub.aegisub.savedState",
  ]
end