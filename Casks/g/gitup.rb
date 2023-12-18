cask "gitup" do
  version "1.3.5"
  sha256 "8cf6c5c24959a33fddf886c29edceb144d5ea68c0cc492a9dc28e737d706b4e4"

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