cask "codeexpander" do
  version "4.3.6"
  sha256 "ed010ce433d31b9a04f82f86474f2ddcda87092e2c9d2060be2bc2e091683167"

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