cask "amethyst" do
  on_el_capitan :or_older do
    version "0.10.1"
    sha256 "9fd1ac2cfb8159b2945a4482046ee6d365353df617f4edbabc4e8cadc448c1e7"

    url "https:ianyh.comamethystversionsAmethyst-#{version}.zip"

    livecheck do
      skip "Legacy version"
    end
  end
  on_sierra :or_newer do
    version "0.20.0"
    sha256 "198a2bbe80832ce77fc584ad20691206a179423551dcf1cbdf46ff1e6f829c09"

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
  depends_on macos: ">= :catalina"

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