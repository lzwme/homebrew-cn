cask "trex" do
  version "1.8.0"
  sha256 "978b6e7b19285212d0223f2f22c6533af0344d6a56cdd472720e6114659cf4b7"

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