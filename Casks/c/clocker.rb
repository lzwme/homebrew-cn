cask "clocker" do
  version "26.10"
  sha256 "24e37c7d761f0e3697d537bb3de70f9450d9fb6184fee97ae3d3a8430a94a611"

  url "https://ghfast.top/https://github.com/n0shake/Clocker/releases/download/#{version.csv.second || version.csv.first}/Clocker.zip",
      verified: "github.com/n0shake/Clocker/"
  name "Clocker"
  desc "Menu bar timezone tracker and compact calendar"
  homepage "https://abhishekbanthia.com/clocker"

  livecheck do
    url :url
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :github_latest do |json, regex|
      version = json["name"]&.[](regex, 1)
      tag_version = json["tag_name"]&.[](regex, 1)
      next if version.blank? || tag_version.blank?

      (version == tag_version) ? tag_version : "#{version},#{tag_version}"
    end
  end

  depends_on macos: ">= :sonoma"

  app "Clocker.app"

  uninstall launchctl: "com.abhishek.ClockerHelper",
            quit:      "com.abhishek.Clocker"

  zap trash: [
    "~/Library/Application Scripts/com.abhishek.Clocker",
    "~/Library/Containers/com.abhishek.Clocker",
    "~/Library/Preferences/com.abhishek.Clocker.plist",
    "~/Library/Preferences/com.abhishek.Clocker.prefs",
    "~/Library/Preferences/com.abhishek.ClockerHelper.plist",
  ]
end