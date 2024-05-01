cask "jupyterlab" do
  arch arm: "arm64", intel: "x64"

  version "4.1.8-1"
  sha256 arm:   "8077566b75b4591d4746d3e7bc21ecb63603f9b3d6de0da69fad629c36d9e778",
         intel: "044d15d3785956ef6e6fb61ad38ba4767ee0b9a29bc2216601392f63387ae267"

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