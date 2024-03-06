cask "dash-dash" do
  arch arm: "arm64", intel: "x86_64"

  version "20.1.0"
  sha256 arm:   "74e5ea72b8221bfbe9f60130798009733ce385b268a2b025f52d2d6942d70c91",
         intel: "73811ba3200c9a3938b5d139697b3f46a261ecb0eb75ce485e310f33166c57b3"

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