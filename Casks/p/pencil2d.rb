cask "pencil2d" do
  version "0.7.0"
  sha256 "2e0d6a2cce4577e0f0f673189658893ec2182e6a16d4332d98dde21c55899595"

  url "https://ghfast.top/https://github.com/pencil2d/pencil/releases/download/v#{version}/pencil2d-mac-#{version}.zip",
      verified: "github.com/pencil2d/pencil/"
  name "Pencil2D"
  name "Pencil2D Animation"
  desc "Open-source tool to make 2D hand-drawn animations"
  homepage "https://www.pencil2d.org/"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Pencil2D.app"

  zap trash: [
    "~/Library/Application Support/Pencil2D",
    "~/Library/Preferences/com.pencil.Pencil.plist",
    "~/Library/Saved Application State/com.pencil2d.Pencil2D.savedState",
  ]

  caveats do
    requires_rosetta
  end
end