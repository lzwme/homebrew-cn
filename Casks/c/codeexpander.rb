cask "codeexpander" do
  version "4.3.7"
  sha256 "664da62e7dbc3875bc4633c401a82fb1bf5f65e6d71449b7d52931fdca5d2c8d"

  url "https:github.comonceworkcodeexpanderreleasesdownload#{version.major_minor}.xCodeExpander-#{version}.dmg"
  name "CodeExpander"
  desc "Cloud synchronisation development tool"
  homepage "https:github.comonceworkcodeexpander"

  livecheck do
    url :url
    regex(^CodeExpander[._-]v?(\d+(?:\.\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "CodeExpander.app"

  zap trash: [
    "~.codeexpander",
    "~Documentscodeexpander",
    "~LibraryLogsCodeexpander",
    "~LibraryPreferencescom.codeexpander.plist",
    "~LibrarySaved Application Statecom.codeexpander.savedState",
  ]
end