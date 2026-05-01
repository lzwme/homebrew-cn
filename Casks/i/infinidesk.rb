cask "infinidesk" do
  version "3.0"
  sha256 "5445df7cb927ab6a3f08f216901f364f3a02b5d97876bfe370fca5f2a9f1ec7d"

  url "https://infinidesk.app/static/download/v#{version}/InfiniDesk.dmg"
  name "InfiniDesk"
  desc "Create multiple virtual desktops, each with unique files, wallpaper and widgets"
  homepage "https://infinidesk.app/"

  livecheck do
    url :homepage
    regex(/Version\s+v?(\d+(?:\.\d+)+)/i)
  end

  depends_on macos: ">= :big_sur"

  app "InfiniDesk.app"

  zap trash: [
    "~/Library/Application Support/Infinidesk",
    "~/Library/Preferences/app.infinidesk.InfiniDesk.plist",
  ]
end