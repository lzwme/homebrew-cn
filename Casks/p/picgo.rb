cask "picgo" do
  arch arm: "arm64", intel: "x64"

  version "2.3.1"
  sha256 arm:   "a2216b8572565a099d8d66b3d425a94e64de3b8b3ecfb7dc2d84f6b2814aa3bb",
         intel: "6522bad65f0abce9e5ce0f5208244ce73660c51a299189aafd754431c03960e3"

  url "https:github.comMolunerfinnPicGoreleasesdownloadv#{version}PicGo-#{version}-#{arch}.dmg"
  name "PicGo"
  desc "Tool for uploading images"
  homepage "https:github.comMolunerfinnPicGo"

  livecheck do
    url :url
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  app "PicGo.app"

  zap trash: [
    "~LibraryApplication Supportpicgo",
    "~LibraryPreferencescom.molunerfinn.picgo.plist",
    "~LibraryServicesUpload pictures with PicGo.workflow",
  ]
end