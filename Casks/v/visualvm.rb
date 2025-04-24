cask "visualvm" do
  version "2.2"
  sha256 "5d429cdd74d40b78d5472c0563932268162832ea09ac77a303ca80e3e2aa1df6"

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