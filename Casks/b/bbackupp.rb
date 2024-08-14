cask "bbackupp" do
  version "2.14.74"
  sha256 "2870ff5a6c5c7b0a6c3af37d52eb6c2c6546dae8cb503aa579363d1d8bd260c5"

  url "https:github.comLakr233BBackuppreleasesdownload#{version}BBackupp.zip"
  name "BBackupp"
  desc "iOS device backup software"
  homepage "https:github.comLakr233BBackupp"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :ventura"

  app "BBackupp.app"

  zap trash: [
    "~DocumentsBBackupp",
    "~LibraryHTTPStorageswiki.qaq.BBackupp",
    "~LibraryHTTPStorageswiki.qaq.BBackupp.binarycookies",
    "~LibraryPreferenceswiki.qaq.BBackupp.plist",
    "~LibrarySaved Application Statewiki.qaq.BBackupp.savedState",
  ]
end