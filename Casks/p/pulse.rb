cask "pulse" do
  version "0.20.0"
  sha256 "ea3b06cea25f2a24f30cc38f2f879d43ae6b1b2868d0cab092bb0e2acfea9a31"

  url "https:github.comkeanPulsereleasesdownload#{version}Pulse-macos.zip",
      verified: "github.comkeanPulse"
  name "Pulse"
  desc "Logger and network inspector"
  homepage "https:kean.blogpulsehome"

  no_autobump! because: :requires_manual_review

  disable! date: "2024-12-16", because: :discontinued

  app "Pulse.app"

  zap trash: [
    "~LibraryApplication Scriptscom.github.kean.pulse",
    "~LibraryContainerscom.github.kean.pulse",
  ]
end