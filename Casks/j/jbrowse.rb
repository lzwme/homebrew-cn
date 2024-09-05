cask "jbrowse" do
  version "2.15.0"
  sha256 "98090befc0220d42d032e4c400d25ca1145f73d86f68ea8b35395848e1af5ad5"

  url "https:github.comGMODjbrowse-componentsreleasesdownloadv#{version}jbrowse-desktop-v#{version}-mac.dmg",
      verified: "github.comGMODjbrowse-components"
  name "jbrowse"
  desc "Genome browser"
  homepage "https:jbrowse.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "JBrowse #{version.major}.app"

  zap trash: [
    "~LibraryApplication Support@jbrowse",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsorg.jbrowse#{version.major}.app.sfl*",
    "~LibraryPreferencesorg.jbrowse#{version.major}.app.plist",
  ]
end