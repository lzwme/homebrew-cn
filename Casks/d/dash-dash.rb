cask "dash-dash" do
  arch arm: "arm64", intel: "x86_64"

  version "21.0.2"
  sha256 arm:   "66e9ea2a2aeebaa54a915a374c578bd6306da312c65af03e047f94268eb3981e",
         intel: "06f798cfd59bc589c114fec838170ac4b261b3bd9dee649582b5baa2409c7777"

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