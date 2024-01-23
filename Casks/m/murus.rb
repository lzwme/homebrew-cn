cask "murus" do
  version "2.4"
  sha256 "908a9234d248d2053b50ff9034209729095d391a150102690be74d8be0909464"

  url "https:github.comTheMurusTeamMurusreleasesdownloadv#{version}murus-#{version}.zip",
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