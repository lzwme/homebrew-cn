cask "visualvm" do
  version "2.1.8"
  sha256 "d80dfc70d2709d20a290a160842cc17197f5b3ffadb456a9407712cb0dc8fd43"

  url "https:github.comoraclevisualvmreleasesdownload#{version}VisualVM_#{version.no_dots}.dmg",
      verified: "github.comoraclevisualvm"
  name "VisualVM"
  desc "All-in-One Java Troubleshooting Tool"
  homepage "https:visualvm.github.io"

  app "VisualVM.app"

  zap trash: [
    "~LibraryApplication SupportVisualVM",
    "~LibraryCachesVisualVM",
  ]

  caveats do
    depends_on_java
  end
end