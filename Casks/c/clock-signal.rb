cask "clock-signal" do
  version "2025-03-20"
  sha256 "8d055f1dea8315548ff40f61d3b5718dbfc433a245ed05efee6f58a47eda5a9d"

  url "https:github.comTomHarteCLKreleasesdownload#{version}Clock.Signal.MacOS.#{version}.zip"
  name "Clock Signal"
  name "CLK"
  desc "Latency-hating emulator of 8- and 16-bit platforms"
  homepage "https:github.comTomHarteCLK"

  depends_on macos: ">= :high_sierra"

  app "Clock Signal.app"

  uninstall quit: "TH.Clock-Signal"

  zap trash: [
    "~LibraryApplication ScriptsTH.Clock-Signal",
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentsth.clock-signal.sfl*",
    "~LibraryContainersTH.Clock-Signal",
  ]
end