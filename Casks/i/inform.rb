cask "inform" do
  version "10.1.2,1_82_3"
  sha256 "01160096f0d19b1674c56c2dd2c8dc6f39b09cdccc1452b549843690c82b4a94"

  url "https:github.comganelsoninformreleasesdownloadv#{version.csv.first}Inform_#{version.csv.first.dots_to_underscores}_macOS_#{version.csv.second}.dmg",
      verified: "github.comganelsoninform"
  name "Inform"
  desc "Writing system for interactive fiction based on natural language"
  homepage "https:ganelson.github.ioinform-website"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+).*?macOS[._-]v?(\d+(?:_\d+)+)\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :mojave"

  app "Inform.app"

  zap trash: [
    "~LibraryApplication Supportcom.apple.sharedfilelistcom.apple.LSSharedFileList.ApplicationRecentDocumentscom.inform7.inform-compiler.sfl*",
    "~LibraryCachescom.inform7.inform-compiler",
    "~LibraryHTTPStoragescom.inform7.inform-compiler",
    "~LibraryInform",
    "~LibraryPreferencescom.inform7.inform-compiler.plist",
    "~LibrarySaved Application Statecom.inform7.inform-compiler.savedState",
    "~LibraryWebKitcom.inform7.inform-compiler",
  ]
end