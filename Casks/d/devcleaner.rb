cask "devcleaner" do
  version "2.7.0-488"
  sha256 "0b27b6748769b57c1889094db6c8bfbdc4d8bf3406f7919fc8bde74f01ebf09f"

  url "https:github.comvashpanxcode-dev-cleanerreleasesdownload#{version.sub(-\d+, "")}DevCleaner-#{version}.zip"
  name "DevCleaner"
  desc "Reclaim storage used for Xcode caches"
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