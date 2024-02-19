cask "jupyterlab" do
  arch arm: "arm64", intel: "x64"

  version "4.1.1-1"
  sha256 arm:   "2a65554e7e5b589a4d9d2c9a14d0362502a1b7a4c072bbca4f38ac551f3b7758",
         intel: "20d2798bc80179d4227c58f45d9ec9763ac9ec4d4e13e4e8e01f54685661e5f5"

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