cask "pure-writer" do
  version "1.9.0,1.9.0"
  sha256 "db9423c6aeb7afb8a089c3ccbc7f6ef248d9c8ad46c36d60c6c3d304a98c0e47"

  url "https:github.comPureWriterdesktopreleasesdownload#{version.csv.first}PureWriter-#{version.csv.second}-macOS.dmg",
      verified: "github.comPureWriterdesktop"
  name "Pure Writer Desktop"
  desc "Desktop version of the Android app"
  homepage "https:writer.drakeet.comdesktop"

  livecheck do
    url :url
    regex(%r{v?(\d+(?:\.\d+)+)PureWriter[._-]v?(\d+(?:\.\d+)+)-macOS\.dmg$}i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["browser_download_url"]&.match(regex)
        next if match.blank?

        "#{match[1]},#{match[2]}"
      end
    end
  end

  no_autobump! because: :requires_manual_review

  pkg "Pure Writer-#{version.csv.second}.pkg"

  uninstall pkgutil: "com.drakeet.purewriter"

  zap trash: "~LibraryPreferencescom.drakeet.purewriter.plist"
end