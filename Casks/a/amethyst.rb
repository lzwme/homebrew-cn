cask "amethyst" do
  on_mojave :or_older do
    version "0.16.1"
    sha256 "52663893e6547d2dd85ba15b871ec222ce4f62dc7150e5ff20d592f9b85a47c5"

    url "https:ianyh.comamethystversionsAmethyst-#{version}.zip"

    livecheck do
      skip "Legacy version"
    end
  end
  on_catalina do
    version "0.22.2"
    sha256 "43b16fadf9d349c5d3f5a406917f60e31d0ea65b1f9fc529b09292e906f75e50"

    url "https:github.comianyhAmethystreleasesdownloadv#{version}Amethyst.zip",
        verified: "github.comianyhAmethyst"

    livecheck do
      skip "Legacy version"
    end
  end
  on_big_sur :or_newer do
    version "0.23.1"
    sha256 "b8c833ffe00585075a8a6935c13cf2a0d5991bc5e6e6f5e3809a1fb5fd2c67a3"

    url "https:github.comianyhAmethystreleasesdownloadv#{version}Amethyst.zip",
        verified: "github.comianyhAmethyst"

    livecheck do
      url "https:ianyh.comamethystappcast.xml"
      strategy :sparkle, &:short_version
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