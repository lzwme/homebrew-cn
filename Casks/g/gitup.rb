cask "gitup" do
  version "1.4.2"
  sha256 "67b2612ef7aac75194b4fb77a27b2a06b031fccac56db71d9e358d362c2e3b25"

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
  depends_on macos: ">= :high_sierra"

  app "GitUp.app"
  binary "#{appdir}GitUp.appContentsSharedSupportgitup"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsco.gitup.mac.sfl*",
    "~LibraryCachesco.gitup.mac",
    "~LibraryHTTPStoragesco.gitup.mac",
    "~LibraryPreferencesco.gitup.mac.plist",
  ]
end