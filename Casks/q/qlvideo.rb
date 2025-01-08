cask "qlvideo" do
  version "2.10"
  sha256 "04a33d736e249ef3791034ccb7b0c286fcdcb0b14b86bf29e370e5cab2168bf3"

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