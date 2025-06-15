cask "micro-sniff" do
  version "1.2.0"
  sha256 "92dbcad769340ab0df851483942003eaa6eaab388773408ef3191edce19b5bbe"

  url "https:github.comdwarvesfmicro-sniffreleasesdownloadv#{version}Micro.Sniff.#{version}.dmg"
  name "Micro Sniff"
  desc "Monitor microphone activity"
  homepage "https:github.comdwarvesfmicro-sniff"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :sierra"

  app "Micro Sniff.app"

  zap trash: [
    "~LibraryApplication Scriptsfoundation.dwarves.microsniff",
    "~LibraryApplication Scriptsfoundation.dwarves.microsnifflauncher",
    "~LibraryContainersfoundation.dwarves.microsniff",
    "~LibraryContainersfoundation.dwarves.microsnifflauncher",
  ]
end