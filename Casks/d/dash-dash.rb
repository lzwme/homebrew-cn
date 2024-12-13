cask "dash-dash" do
  arch arm: "arm64", intel: "x86_64"

  version "22.0.0"
  sha256 arm:   "8411b317a2c4cb5cf279a667b72203f308d58701d58dfbebc3a999113d0cfda4",
         intel: "647ba48f9555de99bb19c1a6538044ddf255aa49a851ea74d3d2d03aab28d463"

  url "https:github.comdashpaydashreleasesdownloadv#{version}dashcore-#{version}-#{arch}-apple-darwin.dmg",
      verified: "github.comdashpaydash"
  name "Dash"
  desc "Dash - Reinventing Cryptocurrency"
  homepage "https:www.dash.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Dash-Qt.app"

  preflight do
    set_permissions "#{staged_path}Dash-Qt.app", "0755"
  end

  zap trash: [
    "~LibraryApplication SupportDashCore",
    "~LibraryPreferencesorg.dash.Dash-Qt.plist",
    "~LibrarySaved Application Stateorg.dash.Dash-Qt.savedState",
  ]
end