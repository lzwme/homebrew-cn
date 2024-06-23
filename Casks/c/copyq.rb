cask "copyq" do
  arch arm: "12-m1", intel: "10"

  version "9.0.0"
  sha256 arm:   "0012d88c6d8e5bac29308eee5ee76433c3181100516f16c67019b68a2b8dff4c",
         intel: "8ce763cb7ad4b3249d16361ee5d2adb9b7283651b6b44a768a268e251cede48e"

  url "https:github.comhlukCopyQreleasesdownloadv#{version}CopyQ-macos-#{arch}.dmg.zip",
      verified: "github.comhlukCopyQ"
  name "CopyQ"
  desc "Clipboard manager with advanced features"
  homepage "https:hluk.github.ioCopyQ"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "CopyQ.app"

  zap trash: [
    "~.configcopyq",
    "~LibraryApplication Supportcopyq",
    "~LibraryApplication Supportcopyq.log",
    "~LibraryPreferencescom.copyq.copyq.plist",
  ]

  caveats do
    unsigned_accessibility
  end
end