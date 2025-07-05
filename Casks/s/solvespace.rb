cask "solvespace" do
  version "3.1"
  sha256 "9d546e09ca2c9611dc38260248f35bd217b3e34857108b93e1086708583619a2"

  url "https://ghfast.top/https://github.com/solvespace/solvespace/releases/download/v#{version}/solvespace.dmg",
      verified: "github.com/"
  name "SolveSpace"
  desc "Parametric 2d/3d CAD"
  homepage "https://solvespace.com/index.pl/"

  no_autobump! because: :requires_manual_review

  app "SolveSpace.app"

  zap trash: [
    "~/Library/Preferences/com.solvespace.plist",
    "~/Library/Saved Application State/com.solvespace.savedState",
  ]
end