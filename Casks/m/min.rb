cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.34.1"
  sha256 arm:   "5d80699b1ab4ea88289bb277ed605007fb784dbf6ef8229a729ca7e72e2b5426",
         intel: "86cf5349ae6a13faa5b015077a630822f8a714bb19b94595794bdb09836e2af4"

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

  auto_updates true
  depends_on macos: ">= :catalina"

  app "Min.app"

  zap trash: [
    "~LibraryApplication SupportMin",
    "~LibraryCachesMin",
    "~LibrarySaved Application Statecom.electron.min.savedState",
  ]
end