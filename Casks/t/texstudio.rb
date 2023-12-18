cask "texstudio" do
  version "4.7.1"
  sha256 "9b17928e1a32ca58199b425509ba88cbfa59a1c151b74e99599bb519b683e8c6"

  url "https:github.comtexstudio-orgtexstudioreleasesdownload#{version}texstudio-#{version}-osx.dmg",
      verified: "github.comtexstudio-orgtexstudio"
  name "TeXstudio"
  desc "LaTeX editor"
  homepage "https:texstudio.org"

  depends_on macos: ">= :big_sur"

  app "texstudio.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentstexstudio.sfl*",
    "~LibraryPreferencestexstudio.plist",
    "~LibrarySaved Application Statetexstudio.savedState",
  ]
end