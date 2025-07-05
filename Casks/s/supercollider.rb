cask "supercollider" do
  version "3.13.0"
  sha256 "fae71509475d66d47bb7b8d204a57a0d6cd4bcb3d9e77c5f2670b916b7160868"

  url "https://ghfast.top/https://github.com/supercollider/supercollider/releases/download/Version-#{version}/SuperCollider-#{version}-macOS-universal.dmg",
      verified: "github.com/supercollider/supercollider/"
  name "SuperCollider"
  desc "Server, language, and IDE for sound synthesis and algorithmic composition"
  homepage "https://supercollider.github.io/"

  livecheck do
    url :url
    regex(/SuperCollider[._-]v?(\d+(?:\.\d+)+)[._-]macOS(?:[._-]universal)?\.dmg/i)
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
    "~/Library/Application Support/SuperCollider",
    "~/Library/Preferences/net.sourceforge.supercollider.plist",
    "~/Library/Saved Application State/net.sourceforge.supercollider.savedState",
  ]
end