cask "tabtab" do
  version "1.3.3"
  sha256 :no_check

  url "https:github.comriccqiTabTabAppreleasesdownloadprodtabtab.dmg",
      verified: "github.comriccqiTabTabApp"
  name "TabTab"
  desc "Window and tab manager"
  homepage "https:tabtabapp.net"

  livecheck do
    url "https:raw.githubusercontent.comriccqiTabTabApprefsheadsmainappcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on macos: ">= :sonoma"

  app "TabTab.app"

  zap trash: [
    "~LibraryCachesriccqi.TabTab",
    "~LibraryHTTPStoragesriccqi.TabTab",
    "~LibraryPreferencesriccqi.TabTab.plist",
  ]
end