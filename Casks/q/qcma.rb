cask "qcma" do
  version "0.4.1,1"
  sha256 "fc286229be41cbeb83fdb8800231f67d8f2f0d51c2fca07f09c7f6e9d4eecca7"

  url "https:github.comcodestationqcmareleasesdownloadv#{version.csv.first}Qcma_#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.comcodestation"
  name "Qcma"
  desc "Cross-platform content manager assistant for the PS Vita"
  homepage "https:codestation.github.ioqcma"

  disable! date: "2024-12-16", because: :discontinued

  app "Qcma.app"
end