cask "purei-play" do
  version "2024-07-29,06517ef0"
  sha256 "c7523b42d832769dfbd970aaef24611091384417b2b644229eb5f188d134514b"

  url "https://playbuilds.s3.amazonaws.com/#{version.csv.second}/Play.dmg",
      verified: "playbuilds.s3.amazonaws.com/"
  name "Play!"
  desc "PlayStation 2 emulator"
  homepage "https://purei.org/"

  livecheck do
    url "https://services.purei.org/api/builds"
    strategy :json do |json|
      "#{json["commitDate"][/^(\d+(?:-\d+)+)T/i, 1]},#{json["commitHash"]}"
    end
  end

  depends_on macos: ">= :catalina"

  app "Play.app"

  zap trash: [
    "~/Library/Preferences/com.virtualapplications.Play.plist",
    "~/Library/Saved Application State/com.virtualapplications.Play.savedState",
  ]
end