cask "jbrowse" do
  version "2.16.1"
  sha256 "0e7ada963a84478ec6a3f9f9d57259c5efa43ce325c4b571623c6dabe40183c4"

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