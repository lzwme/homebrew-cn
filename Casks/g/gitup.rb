cask "gitup" do
  version "1.4.3"
  sha256 "f0f1896dae7a17e3f51f6872cc57a79061ab3f47692d64b5a8216cfb6dddb4dc"

  url "https:github.comgit-upGitUpreleasesdownloadv#{version}GitUp.zip",
      verified: "github.comgit-upGitUp"
  name "GitUp"
  desc "Git interface focused on visual interaction"
  homepage "https:gitup.co"

  livecheck do
    url "https:raw.githubusercontent.comgit-upGitUpmasterappcastsstableappcast.xml"
    strategy :sparkle, &:short_version
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