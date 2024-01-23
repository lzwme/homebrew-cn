cask "clock-signal" do
  version "2024-01-22"
  sha256 "a9fd3a7d9723aad8e61cb6c1c3d354b2d5f573179063087431343e4158ff218b"

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