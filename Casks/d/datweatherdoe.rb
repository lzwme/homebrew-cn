cask "datweatherdoe" do
  on_catalina :or_older do
    version "2.2.0"
    sha256 "0e7c7a9a770f3f7e10a17610e4e8670f3c7050a872b1cb2947bfbbbfda94174f"

    livecheck do
      skip "Legacy version for Catalina and earlier"
    end
  end
  on_big_sur do
    version "3.3.0"
    sha256 "8f122fb410019c4065229b01bb3af9630eceef192f3bcb605ea679c7c9143f4a"

    livecheck do
      skip "Legacy version for Big Sur"
    end
  end
  on_monterey do
    version "3.3.0"
    sha256 "8f122fb410019c4065229b01bb3af9630eceef192f3bcb605ea679c7c9143f4a"

    livecheck do
      skip "Legacy version for Monterey"
    end
  end
  on_ventura :or_newer do
    version "4.2.3"
    sha256 "ab61f97e36a7f0b5d5acb735ef71602a1184a2d7423d3f96eff23fff650dc627"

    livecheck do
      url :url
      strategy :github_latest
    end
  end

  url "https:github.cominderdhirDatWeatherDoereleasesdownload#{version}DatWeatherDoe-#{version}.dmg"
  name "DatWeatherDoe"
  desc "Menu bar weather app"
  homepage "https:github.cominderdhirDatWeatherDoe"

  app "DatWeatherDoe.app"

  zap trash: "~LibraryPreferencescom.inderdhir.DatWeatherDoe.plist"
end