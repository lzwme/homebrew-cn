cask "devcleaner" do
  version "2.7.1-498"
  sha256 "9aecbacd17e576e1db219684ffd9823067e12fd5c85ff19d8c990ba051991bd0"

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

  depends_on macos: ">= :ventura"

  app "DevCleaner.app"

  zap trash: [
    "~LibraryApplication Scriptscom.oneminutegames.XcodeCleaner",
    "~LibraryApplication SupportCrashReporterDevCleaner*.plist",
    "~LibraryContainerscom.oneminutegames.XcodeCleaner",
  ]
end