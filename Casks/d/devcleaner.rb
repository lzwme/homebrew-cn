cask "devcleaner" do
  version "2.6.0-475"
  sha256 "e2d3e8921312eb461009dd6fc2d3cc515537bd716508f722885aaef9da0b4d5d"

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