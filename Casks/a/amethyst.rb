cask "amethyst" do
  on_mojave :or_older do
    version "0.16.1"
    sha256 "52663893e6547d2dd85ba15b871ec222ce4f62dc7150e5ff20d592f9b85a47c5"

    url "https:ianyh.comamethystversionsAmethyst-#{version}.zip"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina :or_newer do
    version "0.21.1"
    sha256 "4c6482aefe9e7976812756f63fa999b855df4d043fec28d38b203554e6070828"

    url "https:github.comianyhAmethystreleasesdownloadv#{version}Amethyst.zip",
        verified: "github.comianyhAmethyst"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  name "Amethyst"
  desc "Automatic tiling window manager similar to xmonad"
  homepage "https:ianyh.comamethyst"

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Amethyst.app"

  zap trash: [
    "~LibraryApplication SupportAmethyst",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.amethyst.amethyst.sfl*",
    "~LibraryCachescom.amethyst.Amethyst",
    "~LibraryCookiescom.amethyst.Amethyst.binarycookies",
    "~LibraryHTTPStoragescom.amethyst.Amethyst",
    "~LibraryPreferencescom.amethyst.Amethyst.plist",
  ]
end