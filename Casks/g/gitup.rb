cask "gitup" do
  version "1.4.0"
  sha256 "35688803564d20bf987e9e6ae7915525a260975ab25bcf99a967423d83a53b2e"

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