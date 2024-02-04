cask "jupyterlab" do
  arch arm: "arm64", intel: "x64"

  version "4.0.12-1"
  sha256 arm:   "dfb77a494c958dc4c8d08dfdba98879598bf353c6b8255ac6d5dd0c8bba91815",
         intel: "62ff8eb3c722555c449e7959f1c93c79e123f157504993d0d9d39db83629fa21"

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