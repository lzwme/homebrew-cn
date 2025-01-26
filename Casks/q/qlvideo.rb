cask "qlvideo" do
  version "2.20"
  sha256 "2949e890dce580c8e6704a87765ae23edcba02f2cc9ac2994234f149daaf4241"

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