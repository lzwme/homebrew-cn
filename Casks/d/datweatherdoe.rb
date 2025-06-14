cask "datweatherdoe" do
  on_monterey :or_older do
    on_catalina :or_older do
      version "2.2.0"
      sha256 "0e7c7a9a770f3f7e10a17610e4e8670f3c7050a872b1cb2947bfbbbfda94174f"
    end
    on_big_sur :or_newer do
      version "3.3.0"
      sha256 "8f122fb410019c4065229b01bb3af9630eceef192f3bcb605ea679c7c9143f4a"
    end

    livecheck do
      skip "Legacy version"
    end
  end
  on_ventura :or_newer do
    version "5.4.0"
    sha256 "8f2c1f3542d840949497bc261ad49496aac392ffbe43b6667c3e9a6875cdfda2"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  url "https:github.cominderdhirDatWeatherDoereleasesdownload#{version}DatWeatherDoe-#{version}.dmg"
  name "DatWeatherDoe"
  desc "Menu bar weather app"
  homepage "https:github.cominderdhirDatWeatherDoe"

  no_autobump! because: :requires_manual_review

  app "DatWeatherDoe.app"

  zap trash: "~LibraryPreferencescom.inderdhir.DatWeatherDoe.plist"
end