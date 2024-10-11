cask "affine" do
  arch arm: "arm64", intel: "x64"

  version "0.17.3"
  sha256 arm:   "ed88072c83261dcf23dc25a0dd50629e9845cdcd0c7a842c072e8159279728d0",
         intel: "a90fbe7bc85ff9d3b9782b5b47663115937b31f9d3a408e72ee27e9efd8b9332"

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