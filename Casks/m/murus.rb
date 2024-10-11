cask "murus" do
  version "2.5.1"
  sha256 "ec2d195f310802ece20ad9db5b335f5c1d636a986fef251a92a871f2ce670f6f"

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