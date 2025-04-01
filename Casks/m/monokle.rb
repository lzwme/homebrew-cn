cask "monokle" do
  version "2.4.8"
  sha256 "43e45f9d67ffec7bcfc4c23ad1adaef6ef81fe4a8d1b95837d18b0ef39b9df84"

  url "https:github.comkubeshopmonoklereleasesdownloadv#{version}Monokle-mac-#{version}-universal.dmg"
  name "Monokle"
  desc "IDE dedicated to high-quality Kubernetes YAML configurations"
  homepage "https:github.comkubeshopmonokle"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: ">= :catalina"

  app "Monokle.app"

  zap trash: [
    "~LibraryApplication Supportmonokle",
    "~LibraryLogsmonokle",
    "~LibraryPreferencesio.kubeshop.monokle.plist",
    "~LibrarySaved Application Stateio.kubeshop.monokle.savedState",
  ]
end