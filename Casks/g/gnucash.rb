cask "gnucash" do
  arch arm: "Arm", intel: "Intel"

  version "5.11-2"
  sha256 arm:   "5e05eeb1f6cf36a90d7309429361a420976fc61e92c7dc983b41662d6a2791b1",
         intel: "f138b2d5f9f8646ad774457988ea0c0cbcb7a81c779c59e06282c03f6c283741"

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