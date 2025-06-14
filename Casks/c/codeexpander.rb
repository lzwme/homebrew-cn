cask "codeexpander" do
  version "4.3.8"
  sha256 "993849b21822b62c29b96d70e7ee306e329ed963d0560ca2ecc2b5e7e23d29e1"

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

  no_autobump! because: :requires_manual_review

  app "CodeExpander.app"

  zap trash: [
    "~.codeexpander",
    "~Documentscodeexpander",
    "~LibraryLogsCodeexpander",
    "~LibraryPreferencescom.codeexpander.plist",
    "~LibrarySaved Application Statecom.codeexpander.savedState",
  ]

  caveats do
    requires_rosetta
  end
end