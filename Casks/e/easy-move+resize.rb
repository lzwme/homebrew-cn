cask "easy-move+resize" do
  version "1.7.0"
  sha256 "5c7bab623ae11bfa1daa48535495f97678532e4d66bcd3920ebe1c303228c53d"

  url "https:github.comdmarcotteeasy-move-resizereleasesdownload#{version}Easy.Move+Resize.app.zip"
  name "Easy Move+Resize"
  desc "Utility to support moving and resizing using a modifier key and mouse drag"
  homepage "https:github.comdmarcotteeasy-move-resize"

  no_autobump! because: :requires_manual_review

  depends_on macos: ">= :high_sierra"

  app "Easy Move+Resize.app"

  zap trash: "~LibraryPreferencesorg.dmarcotte.Easy-Move-Resize.plist"
end