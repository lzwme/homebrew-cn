cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.32.0"
  sha256 arm:   "663f061fc5cc3f511bc2b907f3dc61f447748955eb89d34e94d05799de3fcc58",
         intel: "de25e122f820d8f5b4607c3f4166c921f4924bf9c688057e3fc373f343f31cc2"

  url "https:github.comminbrowserminreleasesdownloadv#{version}min-v#{version}-mac-#{arch}.zip",
      verified: "github.comminbrowsermin"
  name "Min"
  desc "Minimal browser that protects privacy"
  homepage "https:minbrowser.github.iomin"

  app "Min.app"

  zap trash: [
    "~LibraryApplication SupportMin",
    "~LibraryCachesMin",
    "~LibrarySaved Application Statecom.electron.min.savedState",
  ]
end