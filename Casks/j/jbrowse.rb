cask "jbrowse" do
  version "2.13.1"
  sha256 "c4d0cfa83d3e610c04feb479ab5bc65988ffacb3932134aea7d22c71d8573bd3"

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