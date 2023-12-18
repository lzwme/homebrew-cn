cask "nfov" do
  version "1.3.1"
  sha256 "a23ef50f243453cec012a2f2a754fb44b3c5e997a0703feabda53235274c1e69"

  url "https:github.comnrlquakernfovreleasesdownloadv#{version}nfov-darwin-x64-#{version}.zip"
  name "nfov"
  desc "ASCII  ANSI art viewer"
  homepage "https:github.comnrlquakernfov"

  app "nfov.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.electron.nfov.sfl*",
    "~LibraryApplication Supportnfov",
    "~LibraryLogsnfov",
    "~LibraryPreferencescom.electron.nfov.helper.plist",
    "~LibraryPreferencescom.electron.nfov.plist",
    "~LibrarySaved Application Statecom.electron.nfov.savedState",
  ]
end