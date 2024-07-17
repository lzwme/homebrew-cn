cask "visualvm" do
  version "2.1.9"
  sha256 "af6d2274a5dc04fb3aa076f7939c7b7233c0256d006b487ad9a5464341171150"

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