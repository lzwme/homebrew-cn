cask "mixin" do
  version "1.12.1"
  sha256 "09732798585b019f34a696203800be511b4c3d5947b3979a0c1917c3bffb3ba4"

  url "https:github.comMixinNetworkflutter-appreleasesdownloadv#{version}mixin-#{version}.dmg"
  name "Mixin Messenger Desktop"
  desc "Cryptocurrency wallet"
  homepage "https:github.comMixinNetworkflutter-app"

  # Not every GitHub release provides a file for macOS, so we check multiple
  # recent releases instead of only the "latest" release.
  livecheck do
    url :url
    regex(^mixin[._-]v?(\d+(?:\.\d+)+)\.(?:dmg|pkg|zip)$i)
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

  auto_updates true

  app "Mixin.app"

  zap trash: [
    "~LibraryApplication Scriptsone.mixin.messenger.desktop",
    "~LibraryApplication Supportone.mixin.messenger.desktop",
    "~LibraryContainersone.mixin.messenger.desktop",
    "~LibrarySaved Application Stateone.mixin.messenger.desktop.savedState",
  ]
end