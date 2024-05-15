cask "gittyup" do
  version "1.4.0"
  sha256 "5f4485f8f9df41c702baa0ce93be6ec91489ec1d1f7cf3e66e4e5e6deee726ae"

  url "https:github.comMurmeleGittyupreleasesdownloadgittyup_v#{version}Gittyup-#{version}.dmg",
      verified: "github.comMurmeleGittyup"
  name "gittyup"
  desc "Graphical Git client"
  homepage "https:murmele.github.ioGittyup"

  livecheck do
    url :url
    regex(^Gittyup[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  auto_updates true

  app "Gittyup.app"

  zap trash: [
    "~LibraryApplication SupportGittyup",
    "~LibraryPreferencescom.github.gittyup.Gittyup.plist",
    "~LibraryPreferencescom.Murmele.Gittyup.plist",
    "~LibrarySaved Application Statecom.Murmele.Gittyup.savedState",
  ]
end