cask "dash-dash" do
  arch arm: "arm64", intel: "x86_64"

  version "21.1.1"
  sha256 arm:   "cd6543c015a6b811ae2efe33036516155940df836e871f9608b3e8869077dc71",
         intel: "f232337045b54474769162c8c1ec6897eb5cefa4dfc084f92533febf92db867d"

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