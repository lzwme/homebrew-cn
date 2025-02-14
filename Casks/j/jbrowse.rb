cask "jbrowse" do
  version "3.0.3"
  sha256 "065aead783ee01dd8c2e634d032d7b35b20c64c217d5a994106f56c8fc5266f4"

  url "https:github.comGMODjbrowse-componentsreleasesdownloadv#{version}jbrowse-desktop-v#{version}-mac.dmg",
      verified: "github.comGMODjbrowse-components"
  name "JBrowse"
  desc "Genome browser"
  homepage "https:jbrowse.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "JBrowse 2.app"

  zap trash: [
    "~LibraryApplication Support@jbrowse",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.jbrowse*.app.sfl*",
    "~LibraryPreferencesorg.jbrowse*.app.plist",
  ]
end