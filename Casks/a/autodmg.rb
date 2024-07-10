cask "autodmg" do
  version "1.9"
  sha256 "92c10590ef5569797f1879f3b123e0a1f5a0434654a9cc6f6dbb517e779e6a79"

  url "https:github.comMagerValpAutoDMGreleasesdownloadv#{version}AutoDMG-#{version}.dmg"
  name "AutoDMG"
  desc "App for creating deployable system images from a system installer"
  homepage "https:github.comMagerValpAutoDMG"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sierra"

  app "AutoDMG.app"

  zap trash: [
    "~LibraryApplication SupportAutoDMG",
    "~LibraryCachesse.gu.it.AutoDMG",
    "~LibraryLogsAutoDMG",
    "~LibraryPreferencesse.gu.it.AutoDMG.plist",
  ]

  caveats do
    requires_rosetta
  end
end