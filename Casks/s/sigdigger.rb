cask "sigdigger" do
  version "0.3.0"
  sha256 "18314d22fdc0d41061312b02d088f6cb903292c741d1e4f6aa3371c804406c98"

  url "https:github.comBatchDrakeSigDiggerreleasesdownloadv#{version}SigDigger-#{version}-x86_64.dmg",
      verified: "github.comBatchDrakeSigDigger"
  name "SigDigger"
  desc "Qt-based digital signal analyzer"
  homepage "https:batchdrake.github.ioSigDigger"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :high_sierra"

  app "SigDigger.app"

  zap trash: [
    "~LibraryPreferencesorg.actinid.SigDigger.plist",
    "~LibrarySaved Application Stateorg.actinid.SigDigger.savedState",
  ]

  caveats do
    requires_rosetta
  end
end