cask "gitup" do
  version "1.4.1"
  sha256 "6bb185ef1c308a2a74adb09d650e39324dd200948d59495c0e3b464751356cfc"

  url "https:github.comgit-upGitUpreleasesdownloadv#{version}GitUp.zip",
      verified: "github.comgit-upGitUp"
  name "GitUp"
  desc "Git interface focused on visual interaction"
  homepage "https:gitup.co"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  app "GitUp.app"
  binary "#{appdir}GitUp.appContentsSharedSupportgitup"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.gitup.mac.sfl*",
    "~LibraryCachesco.gitup.mac",
    "~LibraryHTTPStoragesco.gitup.mac",
    "~LibraryPreferencesco.gitup.mac.plist",
  ]
end