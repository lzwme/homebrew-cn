cask "kubenav" do
  version "4.2.3"
  sha256 "663785d1dfd9fbbfd9abfe5cf5a86dee40fd8c6ce6fd02ed73f446bf28414fb4"

  url "https:github.comkubenavkubenavreleasesdownloadv#{version}kubenav-macos-universal.zip",
      verified: "github.comkubenavkubenav"
  name "kubenav"
  desc "Navigator for your Kubernetes clusters right in your pocket"
  homepage "https:kubenav.io"

  deprecate! date: "2024-05-31", because: :discontinued
  disable! date: "2025-05-31", because: :discontinued

  depends_on macos: ">= :monterey"

  app "kubenav.app"
  binary "#{appdir}kubenav.appContentsMacOSkubenav"

  zap trash: "~LibrarySaved Application Stateio.kubenav.kubenav.savedState"
end