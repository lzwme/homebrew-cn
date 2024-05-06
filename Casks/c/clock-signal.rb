cask "clock-signal" do
  version "2024-05-05"
  sha256 "7da15fe6bfbe4a74b803899f8cafbd350140d5005c19dac5bd7a8f37fb7c9f8d"

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