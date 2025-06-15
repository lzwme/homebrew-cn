cask "manila" do
  version "1.0.1"
  sha256 "269e11c4f069293f3cd8b93f96f127ef3b62014983f7685efa9e50200796e43c"

  url "https:github.comneilsardesaiManilareleasesdownloadv#{version}Manila.zip"
  name "Manila"
  desc "Finder extension for changing folder colours"
  homepage "https:github.comneilsardesaiManila"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :monterey"

  app "Manila.app"

  zap trash: [
    "~LibraryApplication Scriptscom.NeilSardesai.Manila*",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.neilsardesai.manila.sfl*",
    "~LibraryContainerscom.NeilSardesai.Manila*",
  ]
end