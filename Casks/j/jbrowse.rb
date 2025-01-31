cask "jbrowse" do
  version "3.0.1"
  sha256 "3e1a1f3dd2be24e9d405dbd8534830526a675383e5837048199b51672179e63e"

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