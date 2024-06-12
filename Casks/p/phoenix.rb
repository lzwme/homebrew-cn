cask "phoenix" do
  version "4.0.1"
  sha256 "7d194ca75f33f6c018fe8fb974e372544a61a058222d62d57e6c929fe91949c3"

  url "https:github.comkasperphoenixreleasesdownload#{version}phoenix-#{version}.tar.gz"
  name "Phoenix"
  desc "Window and app manager scriptable with JavaScript"
  homepage "https:github.comkasperphoenix"

  auto_updates true
  depends_on macos: ">= :mojave"

  app "Phoenix.app"

  uninstall quit:       [
              "org.khirviko.Phoenix",
              "org.khirviko.Phoenix.Launcher",
            ],
            login_item: "Phoenix"

  zap trash: [
    "~LibraryApplication Scriptsorg.khirviko.Phoenix.Launcher",
    "~LibraryCachesorg.khirviko.Phoenix",
    "~LibraryContainersorg.khirviko.Phoenix.Launcher",
    "~LibraryHTTPStoragesorg.khirviko.Phoenix",
    "~LibraryWebKitorg.khirviko.Phoenix",
  ]
end