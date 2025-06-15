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
    regex(SuperCollider[._-]v?(\d+(?:\.\d+)+)[._-]macOS(?:[._-]universal)?\.dmgi)
    strategy :github_releases do |json, regex|
      json.map do |release|
        next if release["draft"] || release["prerelease"]

        release["assets"]&.map do |asset|
          match = asset["name"]&.match(regex)
          next if match.blank?

          match[1]
        end
      end.flatten
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "SuperCollider.app"

  zap trash: [
    "~LibraryApplication SupportSuperCollider",
    "~LibraryPreferencesnet.sourceforge.supercollider.plist",
    "~LibrarySaved Application Statenet.sourceforge.supercollider.savedState",
  ]
end