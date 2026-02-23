cask "strawberry" do
  version "0.0.87"
  sha256 "55723a5bd23e89a8fc155653903415fb0e8e918c363817456b6711810e4f05db"

  url "https://strawberrybucket.com/strawberry-#{version}.dmg",
      verified: "strawberrybucket.com/"
  name "Strawberry"
  desc "AI-powered web browser"
  homepage "https://strawberrybrowser.com/"

  livecheck do
    url "https://strawberrybucket.com/latest-mac.yml"
    strategy :electron_builder
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "Strawberry.app"

  zap trash: "~/Library/Application Support/strawberry"
end