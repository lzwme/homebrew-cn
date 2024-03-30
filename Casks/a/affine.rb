cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.13.4"
  sha256 arm:   "1eb646b5dab662809fcda53ae11e4f3f331e3fd6ed78ee4a789a3ea751420214",
         intel: "ff36883da1ab37410d46274dce4f70db8b98c90ae760c992c660eb26faae3616"

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