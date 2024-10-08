cask "visualvm" do
  version "2.1.10"
  sha256 "0130d95ba96e1b3f4a5d58fb9b1e95e8a247a45165af727c0e23354dc0a35b22"

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