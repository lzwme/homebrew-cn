cask "clock-signal" do
  version "2024-10-19"
  sha256 "d2bf396dfe34ca13039b463b12c9fbfb4799e6cfac5dabcddc9d6db1b587a90d"

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