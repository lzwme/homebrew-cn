cask "supercollider" do
  version "3.13.0"
  sha256 "fae71509475d66d47bb7b8d204a57a0d6cd4bcb3d9e77c5f2670b916b7160868"

  url "https:github.comsupercollidersupercolliderreleasesdownloadVersion-#{version}SuperCollider-#{version}-macOS-universal.dmg",
      verified: "github.comsupercollidersupercollider"
  name "SuperCollider"
  desc "Server, language, and IDE for sound synthesis and algorithmic composition"
  homepage "https:supercollider.github.io"

  livecheck do
    url :url
    regex(^Version[._-]v?(\d+(?:\.\d+)+)$i)
  end

  depends_on macos: ">= :mojave"

  app "SuperCollider.app"

  zap trash: [
    "~LibraryApplication SupportSuperCollider",
    "~LibraryPreferencesnet.sourceforge.supercollider.plist",
    "~LibrarySaved Application Statenet.sourceforge.supercollider.savedState",
  ]
end