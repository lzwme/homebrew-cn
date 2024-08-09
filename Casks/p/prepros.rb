cask "prepros" do
  arch arm: "-Mac"

  version "7.26.0"
  sha256 arm:   "8d638cc0947ed94950041740705a9a8b9d94f35424bc9dcc651ff16744c145be",
         intel: "5231ca24adaf7840a491a34fe1ab648e554ddee86db980d358b1b22d7c2947f8"

  url "https://downloads.prepros.io/v#{version.major}/#{version}/Prepros#{arch}-#{version}.zip"
  name "Prepros"
  desc "Web development companion"
  homepage "https://prepros.io/"

  livecheck do
    url "https://prepros.io/api/v#{version.major}/version/darwin/stable"
    strategy :json do |json|
      json.dig("data", "version")
    end
  end

  depends_on macos: ">= :high_sierra"

  app "Prepros.app"

  zap trash: [
    "~/Library/Application Support/Prepros",
    "~/Library/Application Support/Prepros-#{version.major}",
    "~/Library/Preferences/io.prepros.prepros.plist",
    "~/Library/Saved Application State/io.prepros.prepros.savedState",
  ]
end