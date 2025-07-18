cask "suuntodm5" do
  version "1.5.4"
  sha256 :no_check

  url "https://dm5.movescount.com/SuuntoDM5.dmg",
      verified: "dm5.movescount.com/"
  name "Suunto DM5"
  desc "Create dive plans and analyze your dives"
  homepage "https://www.suunto.com/Support/software-support/dm5/"

  livecheck do
    url "https://dm5.movescount.com/ReleaseNotes.txt"
    regex(/Suunto\s*DM5\s+v?(\d+(?:\.\d+)+)/i)
  end

  no_autobump! because: :requires_manual_review

  auto_updates true

  app "SuuntoDM5.app"

  zap trash: "~/Library/Logs/SuuntoDM5"
end