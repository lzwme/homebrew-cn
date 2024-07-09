cask "gnucash" do
  version "5.8-2"
  sha256 "ddfbbecc87db276dc30a164a90b51189702215d4326160346824cb69d7f0ffe9"

  url "https:github.comGnucashgnucashreleasesdownload#{version.hyphens_to_dots.major_minor}Gnucash-Intel-#{version}.dmg",
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

  caveats do
    requires_rosetta
  end
end