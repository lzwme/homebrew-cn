cask "devcleaner" do
  version "2.5.0-458"
  sha256 "4bd24da76c489d744ceee2f5440f9e39bf6468c9f4b2f22f03add3bd43ba2d57"

  url "https:github.comvashpanxcode-dev-cleanerreleasesdownload#{version.sub(-\d+, "")}DevCleaner-#{version}.zip"
  name "DevCleaner"
  desc "Reclaim tens of gigabytes of your storage used for various Xcode caches"
  homepage "https:github.comvashpanxcode-dev-cleaner"

  livecheck do
    url :url
    regex(^DevCleaner[._-]v?(\d+(?:[.-]\d+)+)\.zip$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        match[1]
      end
    end
  end

  app "DevCleaner.app"

  zap trash: [
    "~LibraryApplication Scriptscom.oneminutegames.XcodeCleaner",
    "~LibraryApplication SupportCrashReporterDevCleaner*.plist",
    "~LibraryContainerscom.oneminutegames.XcodeCleaner",
  ]
end