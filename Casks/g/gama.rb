cask "gama" do
  arch arm: "_M1"

  version "1.9.3"
  sha256 arm:   "51051555e5eed50bf92bb5b6957ed1f39fec5a9080e0038b9109ed3d2fe68f08",
         intel: "c29918550d6054374bdb657633db5c795ae07e047a1adab72bfe81f14c671d7f"

  url "https:github.comgama-platformgamareleasesdownload#{version}GAMA_#{version}_MacOS#{arch}.dmg",
      verified: "github.comgama-platformgama"
  name "GAMA Platform"
  desc "IDE for building spatially explicit agent-based simulations"
  homepage "https:gama-platform.org"

  # Using :github_latest as repo contains pre-release tags
  livecheck do
    url :url
    strategy :github_latest
  end

  conflicts_with cask: "gama-jdk"

  app "Gama.app"

  zap trash: [
    "~Gama_Workspace",
    "~LibraryPreferencesGama.plist",
  ]

  caveats do
    depends_on_java "17"
  end
end