cask "jbrowse" do
  version "2.15.4"
  sha256 "83cf0a85a6663fccef9ad66c0cfb349fbd0d227b16fcc9bccf67ca45c2ede898"

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