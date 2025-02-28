cask "clock-signal" do
  version "2025-02-26"
  sha256 "0eadac10d532ba6c4c85d29c56ffe9b74bf29d12170b9a316ba8c3f37da85757"

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