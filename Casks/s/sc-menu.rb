cask "sc-menu" do
  version "1.8.1"
  sha256 "acdf2ba19bb1adc4cacc36554c1d18aa9591f3d4e7b22f437b094e88dfc84855"

  url "https:github.comboberitosc_menureleasesdownload#{version}SC_Menu.dmg"
  name "SC Menu"
  desc "Simple smartcard menu item"
  homepage "https:github.comboberitosc_menu"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "SC Menu.app"

  zap trash: [
    "~LibraryApplication Scriptscom.bob.sc-menu",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.bob.sc-menu.sfl*",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.ttinc.sc-menu.sfl*",
    "~LibraryContainerscom.bob.sc-menu",
  ]
end