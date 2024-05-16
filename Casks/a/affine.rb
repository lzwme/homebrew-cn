cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.14.5"
  sha256 arm:   "0792585d185c0b054612751a5a845f163208aa5c180c041f63a0a1419e3f80b3",
         intel: "076527b392c53073cca74ff1878abf50ac3ea20ea48ddeeb172ccdad4e15d0dc"

  url "https:github.comtoeverythingAFFiNEreleasesdownloadv#{version}affine-#{version}-stable-macos-#{arch}.zip",
      verified: "github.comtoeverythingAFFiNE"
  name "AFFiNE"
  desc "Note editor and whiteboard"
  homepage "https:affine.pro"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :catalina"

  app "AFFiNE.app"

  zap trash: [
    "~LibraryApplication SupportAFFiNE",
    "~LibraryLogsAFFiNE",
    "~LibraryPreferencespro.affine.app.plist",
    "~LibrarySaved Application Statepro.affine.app.savedState",
  ]
end