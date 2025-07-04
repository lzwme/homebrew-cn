cask "opencloud" do
  arch arm: "arm64", intel: "x86_64"

  version "2.0.0"
  sha256 arm:   "b26095f17c2c80babb2e9db2ed447c0d99521c0615e62a3062981aabcd9c3bba",
         intel: "e12b48b2eb183defa33dbdba019de3eff73e8fecf08d5222723444a77252edeb"

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