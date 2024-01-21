cask "sonic-visualiser" do
  version "4.5.2,2851"
  sha256 "d91ce0890fe9fc099fd7dfe4ed725d535f9a5a7da7bacd56130803736597ac6b"

  url "https:github.comsonic-visualisersonic-visualiserreleasesdownloadsv_v#{version.csv.first}Sonic.Visualiser-#{version.csv.first}.dmg",
      verified: "github.comsonic-visualisersonic-visualiser"
  name "Sonic Visualiser"
  desc "Visualisation, analysis, and annotation of music audio recordings"
  homepage "https:www.sonicvisualiser.org"

  livecheck do
    url "https:www.sonicvisualiser.orgdownload.html"
    regex(%r{href=.*?(\d+)Sonic%20Visualiser-(\d+(?:\.\d+)*)\.dmg}i)
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