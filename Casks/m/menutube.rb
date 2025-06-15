cask "menutube" do
  version "1.7.4"
  sha256 "ba7ea5753a270a5300a9a98effaa378a3e1e4305f89c804c1e779b06ebbf5a46"

  url "https:github.comedanchenkovMenuTubereleasesdownload#{version}MenuTube-#{version}.dmg",
      verified: "github.comedanchenkovMenuTube"
  name "MenuTube"
  desc "Tool to capture YouTube into the menu bar"
  homepage "https:edanchenkov.github.ioMenuTube"

  no_autobump! because: :requires_manual_review

  app "MenuTube.app"

  zap trash: [
    "~LibraryApplication SupportMenuTube",
    "~LibraryPreferencescom.rednuclearmonkey.menutube.plist",
    "~LibrarySaved Application Statecom.rednuclearmonkey.menutube.savedState",
  ]

  caveats do
    requires_rosetta
  end
end