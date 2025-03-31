cask "gnucash" do
  arch arm: "Arm", intel: "Intel"

  version "5.11-1"
  sha256 arm:   "ad69a4bcca4b54a910ed71d8e2d184bae30146237ad14b3b9c7810a60ba1f1f5",
         intel: "0d15de4acfd8bffdd6a4ecc010f4244218c770c2964aa65f889e4b9cecd7dd3c"

  url "https:github.comGnucashgnucashreleasesdownload#{version.hyphens_to_dots.major_minor}Gnucash-#{arch}-#{version}.dmg",
      verified: "github.comGnucashgnucash"
  name "GnuCash"
  desc "Double-entry accounting program"
  homepage "https:www.gnucash.org"

  livecheck do
    url :url
    regex(^Gnucash-#{arch}[._-]v?(\d+(?:[.-]\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Gnucash.app"

  zap trash: [
    "~LibraryApplication SupportGnucash",
    "~LibraryPreferencesorg.gnucash.Gnucash.plist",
    "~LibrarySaved Application Stateorg.gnucash.Gnucash.savedState",
  ]
end