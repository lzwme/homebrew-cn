cask "sonic-visualiser" do
  version "5.0.1,2869"
  sha256 "d719b1b97682f679b7a33f66fb5ce3c54d9fbd596e4076248c3b70dbc1398464"

  url "https:github.comsonic-visualisersonic-visualiserreleasesdownloadsv_v#{version.csv.first}Sonic.Visualiser.#{version.csv.first}.dmg",
      verified: "github.comsonic-visualisersonic-visualiser"
  name "Sonic Visualiser"
  desc "Visualisation, analysis, and annotation of music audio recordings"
  homepage "https:www.sonicvisualiser.org"

  livecheck do
    url "https:www.sonicvisualiser.orgdownload.html"
    regex(%r{href=.*?(\d+)Sonic%20Visualiser%20(\d+(?:\.\d+)*)\.dmg}i)
    strategy :page_match do |page, regex|
      page.scan(regex).map { |match| "#{match[1]},#{match[0]}" }
    end
  end

  depends_on macos: ">= :sierra"

  app "Sonic Visualiser.app"

  zap trash: [
    "~LibraryApplication Supportsonic-visualiser",
    "~LibraryPreferencesorg.sonicvisualiser.Sonic Visualiser.plist",
    "~LibraryPreferencesorg.sonicvisualiser.SonicVisualiser.plist",
    "~LibrarySaved Application Stateorg.sonicvisualiser.SonicVisualiser.savedState",
  ]
end