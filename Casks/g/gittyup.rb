cask "gittyup" do
  version "1.3.0"
  sha256 "8582bc3e8628523d08515356a7e9655e519e2872dbfdcc6f2925a80188ac5ac6"

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
    "~LibraryPreferencescom.Murmele.Gittyup.plist",
    "~LibraryPreferencescom.github.gittyup.Gittyup.plist",
    "~LibrarySaved Application Statecom.Murmele.Gittyup.savedState",
  ]
end