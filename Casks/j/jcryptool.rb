cask "jcryptool" do
  version "1.0.9"
  sha256 "58ba00b265e0180eb3e68f82a8978603fe1112af88ff747959e35bd11b9d79ee"

  url "https:github.comjcryptoolcorereleasesdownload#{version}JCrypTool-#{version}-macOS-64bit.tar.gz",
      verified: "github.comjcryptoolcore"
  name "JCrypTool"
  desc "Apply and analyze cryptographic algorithms"
  homepage "https:www.cryptool.orgenjctdownloads"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "JCrypTool.app"

  zap trash: [
    "~LibraryApplication SupportJCrypTool",
    "~LibraryCachesorg.jcryptool.JCrypTool",
    "~LibraryPreferencesorg.jcryptool.JCrypTool.plist",
    "~LibrarySaved Application Stateorg.jcryptool.JCrypTool.savedState",
  ]

  caveats do
    depends_on_java "11"
    requires_rosetta
  end
end