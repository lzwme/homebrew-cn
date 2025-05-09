cask "murus" do
  version "2.6"
  sha256 "36e4be4435c2c0f358a5aade9d0934d330054354621ce243f3f0bab52d371121"

  url "https:github.comTheMurusTeamMurusreleasesdownloadv#{version}murus-#{version}.zip",
      verified: "github.comTheMurusTeamMurus"
  name "Murus Firewall"
  desc "Firewall app"
  homepage "https:www.murusfirewall.com"

  depends_on macos: ">= :sierra"

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