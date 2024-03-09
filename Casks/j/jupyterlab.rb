cask "jupyterlab" do
  arch arm: "arm64", intel: "x64"

  version "4.1.4-1"
  sha256 arm:   "0d4983978671e93e6d752e5cf10f0bcb2dcdcac3710935a7d9fedfdfc84c69dc",
         intel: "01a3ee3204d54be8a8a774d5f88dcbd053bde7ce5d2222a4af9c013abed1dc82"

  url "https:github.comjupyterlabjupyterlab-desktopreleasesdownloadv#{version}JupyterLab-Setup-macOS-#{arch}.dmg"
  name "JupyterLab App"
  desc "Desktop application for JupyterLab"
  homepage "https:github.comjupyterlabjupyterlab-desktop"

  livecheck do
    url :url
    regex(v?(\d+(?:[.-]\d+)+)i)
    strategy :github_latest
  end

  app "JupyterLab.app"

  uninstall pkgutil: "com.electron.jupyterlab-desktop",
            # See https:github.comjupyterlabjupyterlab-desktopblobmasteruser-guide.md#uninstalling-jupyterlab-desktop
            delete:  [
              "usrlocalbinjlab",
              "~Libraryjupyterlab-desktop",
            ]

  zap trash: [
    "~.jupyter",
    "~LibraryApplication Supportjupyterlab-desktop",
    "~LibraryCachesorg.jupyter.jupyterlab-desktop",
    "~LibraryCachesorg.jupyter.jupyterlab-desktop.ShipIt",
    "~LibraryHTTPStoragesorg.jupyter.jupyterlab-desktop",
    "~LibraryJupyter",
    "~LibraryLogsJupyterLab",
    "~LibraryLogsjupyterlab-desktop",
    "~LibraryPreferencescom.electron.jupyterlab-desktop.plist",
    "~LibrarySaved Application Statecom.electron.jupyterlab-desktop.savedState",
  ]
end