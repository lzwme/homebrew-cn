cask "jupyterlab-app" do
  arch arm: "arm64", intel: "x64"

  version "4.2.5-1"
  sha256 arm:   "189e5e1294cc646b11701e06e41b3d91159bfe8b7913eebdf76a5d5512e0af38",
         intel: "23ba65b91957a202239beeb19d4f94603de1837d59f81576d262d68b4c106b3e"

  url "https:github.comjupyterlabjupyterlab-desktopreleasesdownloadv#{version}JupyterLab-Setup-macOS-#{arch}.dmg"
  name "JupyterLab App"
  desc "Desktop application for JupyterLab"
  homepage "https:github.comjupyterlabjupyterlab-desktop"

  livecheck do
    url :url
    regex(v?(\d+(?:[.-]\d+)+)i)
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

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