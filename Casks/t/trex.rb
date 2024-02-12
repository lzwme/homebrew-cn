cask "trex" do
  version "1.7.0"
  sha256 "aa98677ef0d9301e43e58d876b4cbd220ab82476f02659369118c3476e8d6221"

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