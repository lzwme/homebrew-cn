cask "qlvideo" do
  version "2.21"
  sha256 "b250d1a33978bf474693440b4d269331ef59700dfc7f97d116a8013f369b3a43"

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

  depends_on macos: ">= :monterey"

  app "QuickLook Video.app"

  zap trash: [
    "~LibraryApplication Scripts*.qlvideo",
    "~LibraryApplication Scriptscom.apple.uk.org.marginal.qlvideo.thumbnailer",
    "~LibraryContainerscom.apple.uk.org.marginal.qlvideo.thumbnailer",
    "~LibraryGroup Containers*.qlvideo",
    "~LibrarySaved Application Statecom.apple.uk.org.marginal.qlvideo.savedState",
  ]
end