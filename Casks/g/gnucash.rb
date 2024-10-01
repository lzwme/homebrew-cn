cask "gnucash" do
  arch arm: "Arm", intel: "Intel"

  version "5.9-1"
  sha256 arm:   "ab56dc3d9e7e07ad5b3abd97e181070780d62010a4184ff826bbe935a7d84a1d",
         intel: "ebb05ce936059a1f6d5ceecd2de2de4aa7a5808210b35c8df318cdce9fc40475"

  url "https:github.comGnucashgnucashreleasesdownload#{version.hyphens_to_dots.major_minor}Gnucash-#{arch}-#{version}.dmg",
      verified: "github.comGnucashgnucash"
  name "GnuCash"
  desc "Double-entry accounting program"
  homepage "https:www.gnucash.org"

  livecheck do
    url :url
    regex(^Gnucash-Intel[._-]v?(\d+(?:[.-]\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "Gnucash.app"

  zap trash: [
    "~LibraryApplication SupportGnucash",
    "~LibraryPreferencesorg.gnucash.Gnucash.plist",
    "~LibrarySaved Application Stateorg.gnucash.Gnucash.savedState",
  ]
end