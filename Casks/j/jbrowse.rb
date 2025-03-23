cask "jbrowse" do
  version "3.2.0"
  sha256 "284c058b9e0a3a3af83ac307b2d5bb6a48990085ac9200a4ea27b6c3e71f1910"

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