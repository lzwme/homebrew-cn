cask "jbrowse" do
  version "3.0.4"
  sha256 "86e782a7d970fc827769302bbb7902c9fb0fb3ffeaeac3957e6c227195f6192f"

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