cask "superduper" do
  version "3.10.0,135"
  sha256 :no_check

  url "https://shirtpocket.s3.amazonaws.com/SuperDuper/SuperDuper!.dmg",
      verified: "shirtpocket.s3.amazonaws.com/SuperDuper/"
  name "SuperDuper!"
  desc "Backup, recovery and cloning software"
  homepage "https://www.shirt-pocket.com/SuperDuper/SuperDuperDescription.html"

  livecheck do
    url "https://shirtpocket.s3.amazonaws.com/SuperDuper/superduperinfo.rtf"
    regex(/v?(\d+(?:\.\d+)+)\s*\(v?(\d+)\)/i)
    strategy :page_match do |page, regex|
      match = page.match(regex)
      next if match.blank?

      "#{match[1]},#{match[2]}"
    end
  end

  no_autobump! because: :requires_manual_review

  auto_updates true
  depends_on macos: ">= :high_sierra"

  app "SuperDuper!.app"

  zap trash: [
    "~/Library/Application Support/SuperDuper!",
    "~/Library/Caches/com.blacey.SuperDuper",
    "~/Library/Preferences/com.blacey.SuperDuper.plist",
    "~/Library/Preferences/com.paradigmasoft.VStudio",
    "~/Library/Preferences/com.paradigmasoft.vstudio.plist",
    "~/Library/Saved Application State/com.blacey.SuperDuper.savedState",
    "~/Library/Services/Run SuperDuper! Settings.workflow",
  ]
end