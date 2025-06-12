cask "textgrabber2" do
  # NOTE: "2" is not a version number, but an intrinsic part of the product name
  version "1.5.0"
  sha256 "995f6d865e8f467e3baebf8d8f6c01e17752bdd6a25d876f5696f92984db0870"

  url "https:github.comTextGrabber2-appTextGrabber2releasesdownloadv#{version}TextGrabber2-#{version}.dmg"
  name "TextGrabber2"
  desc "Menu bar app that detects text from copied images"
  homepage "https:github.comTextGrabber2-appTextGrabber2"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :sonoma"

  app "TextGrabber2.app"

  uninstall quit:       "app.cyan.textgrabber2",
            login_item: "TextGrabber2"

  zap trash: [
    "~LibraryApplication Scriptsapp.cyan.textgrabber2",
    "~LibraryContainersapp.cyan.textgrabber2",
  ]
end