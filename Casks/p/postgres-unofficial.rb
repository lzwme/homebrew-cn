cask "postgres-unofficial" do
  version "2.7.3,12-13-14-15-16"
  sha256 "dccd978ee731d2fdc303650709080de7bf54667661757ccde45c3c4c50006f92"

  url "https:github.comPostgresAppPostgresAppreleasesdownloadv#{version.csv.first}Postgres-#{version.csv.first}-#{version.csv.second}.dmg",
      verified: "github.comPostgresAppPostgresApp"
  name "Postgres"
  desc "App wrapper for Postgres"
  homepage "https:postgresapp.com"

  livecheck do
    url :url
    regex(^Postgres[._-]v?(\d+(?:\.\d+)+)[._-](\d+(?:-\d+)+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  auto_updates true
  depends_on macos: ">= :sierra"

  app "Postgres.app"

  uninstall launchctl: "com.postgresapp.Postgres#{version.major}LoginHelper",
            quit:      [
              "com.postgresapp.Postgres#{version.major}",
              "com.postgresapp.Postgres#{version.major}MenuHelper",
            ]

  zap trash: [
    "~LibraryApplication SupportPostgres",
    "~LibraryCachescom.postgresapp.Postgres#{version.major}",
    "~LibraryCookiescom.postgresapp.Postgres#{version.major}.binarycookies",
    "~LibraryPreferencescom.postgresapp.Postgres#{version.major}.plist",
  ]
end