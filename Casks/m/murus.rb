cask "murus" do
  version "2.5"
  sha256 "a626a58ddb9b918fefad08a482e0691bd78f1b32c3c0bafb9a3fb404b21c32d2"

  url "https:github.comTheMurusTeamMurusreleasesdownloadv#{version}Murus.#{version}.zip",
      verified: "github.comTheMurusTeamMurus"
  name "Murus Firewall"
  desc "Firewall app"
  homepage "https:www.murusfirewall.com"

  app "Murus.app"

  uninstall launchctl: "it.murus.murusfirewallrules"

  zap trash: [
    "etcmurus",
    "etcmurus.sh",
    "LibraryApplication SupportMurus",
    "LibraryPreferencesit.murus.muruslibrary.plist",
    "~LibraryCachesit.murus.Murus",
    "~LibraryPreferencesit.murus.Murus.plist",
  ]
end