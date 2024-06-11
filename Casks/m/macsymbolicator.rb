cask "macsymbolicator" do
  version "2.6"
  sha256 "d92f53c23e69997974df3944aa9ab5feb0d9c320dce3e13b2e7088677cd2b509"

  url "https:github.cominketMacSymbolicatorreleasesdownload#{version}MacSymbolicator.zip"
  name "MacSymbolicator"
  desc "Symbolicate Apple related crash reports"
  homepage "https:github.cominketMacSymbolicator"

  depends_on macos: ">= :mojave"

  app "MacSymbolicator.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsjp.mahdi.macsymbolicator.sfl*",
    "~LibraryCachesjp.mahdi.MacSymbolicator",
    "~LibraryHTTPStoragesjp.mahdi.MacSymbolicator",
    "~LibraryPreferencesjp.mahdi.MacSymbolicator.plist",
  ]
end