cask "themeengine" do
  version "1.0.0,111"
  sha256 "2f7039bf8a30a20da20b292252759a501d15962f909d3b2274db9c2ec7a3bf39"

  url "https:github.comalexzielenskiThemeEnginereleasesdownload#{version.csv.first}(#{version.csv.second})ThemeEngine_111.zip"
  name "ThemeEngine"
  desc "App to edit compiled .car files"
  homepage "https:github.comalexzielenskiThemeEngine"

  deprecate! date: "2024-10-31", because: :unmaintained

  app "ThemeEngine.app"

  zap trash: "~LibraryPreferencescom.alexzielenski.ThemeEngine.LSSharedFileList.plist"

  caveats do
    requires_rosetta
  end
end