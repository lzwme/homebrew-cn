cask "jbrowse" do
  version "3.3.0"
  sha256 "ab66aec5fcad32bab481408aff4a94eda3563241b4cb8f54b9584783f77ed270"

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