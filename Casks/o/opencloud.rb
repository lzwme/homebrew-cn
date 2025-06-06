cask "opencloud" do
  arch arm: "arm64", intel: "x86_64"

  version "1.0.0"
  sha256 arm:   "9f98e18b6dfa4164198d8b3abae2855d11e5da89dd75e99cd50f2ca8b15cf625",
         intel: "a9b44fea546040377f9c2bcce6da616cc0618603480e5df59f7ed20b7a427edf"

  url "https:github.comopencloud-eudesktopreleasesdownloadv#{version}OpenCloud_Desktop-v#{version}-macos-clang-#{arch}.pkg"
  name "OpenCloud Desktop"
  desc "Desktop syncing client for OpenCloud"
  homepage "https:github.comopencloud-eudesktop"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  pkg "OpenCloud_Desktop-v#{version}-macos-clang-#{arch}.pkg"

  uninstall pkgutil: [
    "eu.opencloud.client",
    "eu.opencloud.desktop",
    "eu.opencloud.finderPlugin",
  ]

  zap trash: [
    "~LibraryApplication Scriptseu.opencloud.desktopclient.FinderSyncExt",
    "~LibraryApplication SupportOpenCloud",
    "~LibraryCacheseu.opencloud.desktopclient",
    "~LibraryContainerseu.opencloud.desktopclient.FinderSyncExt",
    "~LibraryGroup Containers9B5WD74GWJ.eu.opencloud.desktopclient",
    "~LibraryPreferenceseu.opencloud.desktopclient.plist",
    "~LibraryPreferencesOpenCloud",
  ]
end