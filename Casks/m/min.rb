cask "min" do
  arch arm: "arm64", intel: "x86"

  version "1.32.1"
  sha256 arm:   "02eddf536da721eea11f1fd035ac7e2e067d1868904df6ca9184fdc09082c182",
         intel: "b78ed297534b7fd5ff9f62dee8c66218a3c13eae4497103c06febbfe0d90e90c"

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