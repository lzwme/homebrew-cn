cask "qlvideo" do
  version "2.00"
  sha256 "e4ebad7c0fba9f57038f38956931ab57676ac007198d5a8056fbc0c9ad6af96c"

  url "https:github.comMarginalQLVideoreleasesdownloadrel-#{version.no_dots}QLVideo_#{version.no_dots}.dmg"
  name "QuickLook Video"
  desc "Thumbnails, static previews, cover art and metadata for video files"
  homepage "https:github.comMarginalQLVideo"

  livecheck do
    url :url
    regex(^QLVideo[._-]v?(\d+?)(\d+)\.dmg$i)
    strategy :github_latest do |json, regex|
      json["assets"]&.map do |asset|
        match = asset["name"]&.match(regex)
        next if match.blank?

        "#{match[1]}.#{match[2]}"
      end
    end
  end

  depends_on macos: ">= :high_sierra"

  app "QuickLook Video.app"

  zap trash: [
    "~LibraryApplication Scripts*.qlvideo",
    "~LibraryApplication Scriptscom.apple.uk.org.marginal.qlvideo.thumbnailer",
    "~LibraryContainerscom.apple.uk.org.marginal.qlvideo.thumbnailer",
    "~LibraryGroup Containers*.qlvideo",
    "~LibrarySaved Application Statecom.apple.uk.org.marginal.qlvideo.savedState",
  ]
end