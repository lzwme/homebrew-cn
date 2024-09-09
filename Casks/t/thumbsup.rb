cask "thumbsup" do
  version "4.5.3"
  sha256 "05e1bbefd09e098eeb7faec29ea7556f76cf17b49be719af93e443d993beeb8c"

  url "https://download.devontechnologies.com/download/freeware/thumbsup/#{version}/ThumbsUp.app.zip"
  name "ThumbsUp"
  desc "Batch image thumbnail generation utility"
  homepage "https://www.devontechnologies.com/apps/freeware"

  livecheck do
    url :homepage
    regex(%r{href=.*?/thumbsup/v?(\d+(?:\.\d+)+)/ThumbsUp\.app\.zip}i)
  end

  app "ThumbsUp.app"

  zap trash: [
    "~/Library/Caches/com.apple.helpd/Generated/com.devontechnologies.thumbsup.help*",
    "~/Library/Caches/com.devon-technologies.ThumbsUp",
    "~/Library/Preferences/com.devon-technologies.ThumbsUp.plist",
    "~/Library/Saved Application State/com.devon-technologies.ThumbsUp.savedState",
  ]

  caveats do
    requires_rosetta
  end
end