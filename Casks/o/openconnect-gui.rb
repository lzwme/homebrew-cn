cask "openconnect-gui" do
  version "1.5.3"
  sha256 "b4e5c8618cb327cd3ba612a25976d7df7b49f612669f90488d8c680e32f8f61f"

  url "https:github.comopenconnectopenconnect-guireleasesdownloadv#{version}openconnect-gui-#{version}.high_sierra.bottle.tar.gz",
      verified: "github.comopenconnectopenconnect-gui"
  name "OpenConnect-GUI"
  desc "GitLab mirror - Graphical OpenConnect client (beta phase)"
  homepage "https:openconnect.github.ioopenconnect-gui"

  app "openconnect-gui#{version}OpenConnect-GUI.app"

  zap delete: [
    "~LibraryApplication SupportOpenConnect-GUI Team",
    "~LibraryPreferencesio.github.openconnect.openconnect-gui.plist",
  ]

  caveats do
    discontinued
  end
end