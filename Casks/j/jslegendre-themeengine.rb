cask "jslegendre-themeengine" do
  version "1.0.0,118"
  sha256 "5d471654427f192c9729362b157fa18d0c485371cd9f3fd32ecf23831bfa05c9"

  url "https:github.comjslegendreThemeEnginereleasesdownloadv#{version.csv.first}(#{version.csv.second})ThemeEngine.zip"
  name "ThemeEngine"
  desc "App to edit compiled .car files"
  homepage "https:github.comjslegendreThemeEngine"

  livecheck do
    url :url
    strategy :git do |tags|
      tags.filter_map do |tag|
        match = tag.match(^v(\d+(?:\.\d+)*)\((\d+)\)$i)
        "#{match[1]},#{match[2]}" if match
      end
    end
  end

  depends_on macos: ">= :big_sur"

  app "ThemeEngine.app"

  zap trash: "~LibraryPreferencescom.alexzielenski.ThemeEngine.plist"
end