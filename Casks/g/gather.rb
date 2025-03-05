cask "gather" do
  arch arm: "-arm64"

  version "1.28.0"
  sha256 arm:   "f20bdd5f465d1f381f722dd2b33818364307a4571dd10731dbe1784ae0281375",
         intel: "896d751d42e099f60afcb0577f2ba54bfba72b89db4e92ebccd4e8e1449a5320"

  url "https:github.comgathertowngather-town-desktop-releasesreleasesdownloadv#{version}Gather-#{version}#{arch}-mac.zip",
      verified: "github.comgathertowngather-town-desktop-releases"
  name "Gather Town"
  desc "Virtual video-calling space"
  homepage "https:gather.town"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :big_sur"

  app "Gather.app"

  zap trash: [
    "~LibraryApplication SupportGather",
    "~LibraryLogsGather",
    "~LibraryPreferencescom.gather.Gather.plist",
    "~LibrarySaved Application Statecom.gather.Gather.savedState",
  ]
end