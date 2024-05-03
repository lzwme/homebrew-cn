cask "gzdoom" do
  version "4.12.2"
  sha256 "3903827fcd8a81053f504fc1bfc55d4eba16b2651029b85b4284e51f0709bff6"

  url "https:github.comZDoomgzdoomreleasesdownloadg#{version}gzdoom-#{version.dots_to_hyphens}-macOS.zip"
  name "GZDoom"
  desc "Adds an OpenGL renderer to the ZDoom source port"
  homepage "https:github.comZDoomgzdoom"

  livecheck do
    url :url
    regex(^g?(\d+(?:\.\d+)+)$i)
  end

  app "GZDoom.app"

  zap trash: "~LibraryPreferencesgzdoom.ini"
end