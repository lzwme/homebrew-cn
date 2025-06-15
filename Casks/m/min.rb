cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.35.0"
  sha256 arm:   "18cc5299be51b4038f1969a09a2bb1a4aaf7ac4868c5439835a6ff6563f7fb0f",
         intel: "25316857990ca26b1b2701fd26a0774e5160cd47731b4a8314dda4f46b80fd7f"

  url "https:github.comminbrowserminreleasesdownloadv#{version}min-v#{version}-mac-#{arch}.zip",
      verified: "github.comminbrowsermin"
  name "Min"
  desc "Minimal browser that protects privacy"
  homepage "https:minbrowser.org"

  livecheck do
    url "https:minbrowser.orgminupdateslatestVersion.json"
    strategy :json do |json|
      json["version"]
    end
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Min.app"

  zap trash: [
    "~LibraryApplication SupportMin",
    "~LibraryCachesMin",
    "~LibrarySaved Application Statecom.electron.min.savedState",
  ]
end