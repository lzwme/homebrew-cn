cask "anypointstudio" do
  arch arm: "Arm", intel: "64"

  version "7.19.0"
  sha256 arm:   "04a827b4c4f93f59fb0ae1af8d47243d302eb159a7fe309cf03f85972cdaff77",
         intel: "c376fe68e453f3abf7dba546601fbb05870eb699d084400735999d954c577a0e"

  url "https://mule-studio.s3.amazonaws.com/#{version}-GA/AnypointStudio-#{version}-macos#{arch}.zip",
      verified: "mule-studio.s3.amazonaws.com/"
  name "Anypoint Studio"
  desc "Eclipse-based IDE for designing and testing Mule applications"
  homepage "https://www.mulesoft.com/platform/studio"

  livecheck do
    url "https://docs.mulesoft.com/release-notes/studio/anypoint-studio"
    regex(/Anypoint\s+Studio\s+v?(\d+(?:\.\d+)+)/i)
  end

  depends_on macos: ">= :big_sur"

  app "AnypointStudio.app"

  uninstall delete: "/Library/Logs/DiagnosticReports/AnypointStudio*.diag"

  # No zap stanza required
end