cask "trex" do
  version "1.8.1"
  sha256 "a7031d1c3cfe0af18afe21c9d69cd9dc5e60a864d25e36de3a8acb1b2fd4836f"

  url "https:github.comamebalabsTRexreleasesdownloadv#{version}TRex.zip",
      verified: "github.comamebalabsTRex"
  name "TRex"
  desc "Easy to use text extraction tool"
  homepage "https:trex.ameba.co"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

  app "TRex.app"

  zap trash: [
    "~LibraryApplication Scriptscom.ameba.TRex-LaunchAtLoginHelper",
    "~LibraryCachescom.ameba.TRex",
    "~LibraryContainerscom.ameba.TRex-LaunchAtLoginHelper",
    "~LibraryPreferencescom.ameba.TRex.plist",
  ]
end