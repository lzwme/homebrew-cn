cask "dash-dash" do
  arch arm: "arm64", intel: "x86_64"

  version "22.1.0"
  sha256 arm:   "4d19310ee4bd93aa4cd254bbe842155e1ecb8ead5519b25792f6aa9399c38c65",
         intel: "d00deb355e9187c644b9afc15903acde294a5152fa81e97623f83731c82841c5"

  url "https:github.comdashpaydashreleasesdownloadv#{version}dashcore-#{version}-#{arch}-apple-darwin.zip",
      verified: "github.comdashpaydash"
  name "Dash"
  desc "Dash - Reinventing Cryptocurrency"
  homepage "https:www.dash.org"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :big_sur"

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