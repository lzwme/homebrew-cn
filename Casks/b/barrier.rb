cask "barrier" do
  version "2.4.0"
  sha256 "af938d17dcea5701da7a990705acbd0686dfedfdbcd64721666ae0bef7644ba9"

  url "https:github.comdebaucheebarrierreleasesdownloadv#{version}Barrier-#{version}-Release.dmg"
  name "Barrier"
  desc "Open-source KVM software"
  homepage "https:github.comdebaucheebarrier"

  depends_on macos: ">= :sierra"

  app "Barrier.app"

  zap trash: [
    "~LibraryApplication Supportbarrier",
    "~LibrarySaved Application Statebarrier.savedState",
  ]

  caveats do
    requires_rosetta
  end
end