cask "phoenix" do
  version "4.0.0"
  sha256 "174ebec4c7860d014d02441867721a14342521c0a9482a0fa8605f644b3a40b2"

  url "https:github.comkasperphoenixreleasesdownload#{version}phoenix-#{version}.tar.gz"
  name "Phoenix"
  desc "Window and app manager scriptable with JavaScript"
  homepage "https:github.comkasperphoenix"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Phoenix.app"

  uninstall login_item: "Phoenix",
            quit:       [
              "org.khirviko.Phoenix",
              "org.khirviko.Phoenix.Launcher",
            ]

  zap trash: [
    "~LibraryApplication Scriptsorg.khirviko.Phoenix.Launcher",
    "~LibraryCachesorg.khirviko.Phoenix",
    "~LibraryContainersorg.khirviko.Phoenix.Launcher",
    "~LibraryHTTPStoragesorg.khirviko.Phoenix",
    "~LibraryWebKitorg.khirviko.Phoenix",
  ]
end