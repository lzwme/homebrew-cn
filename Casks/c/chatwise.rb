cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.81"
  sha256 arm:   "4f6c7ad3853ad3b79c0a2fc7197f7cf7dc3b57c1c39f81f08697d9284834e208",
         intel: "e34956b83ba4a383f04b5eb8694afa214a38b238b7fcaf9eb5635e2794f262a2"

  url "https://ghfast.top/https://github.com/egoist/chatwise-releases/releases/download/v#{version}/ChatWise_#{version}_#{arch}.dmg",
      verified: "github.com/egoist/chatwise-releases/"
  name "ChatWise"
  desc "AI chatbot for many LLMs"
  homepage "https://chatwise.app/"

  livecheck do
    url "https://chatwise.app/api/trpc/getReleases"
    strategy :json do |json|
      json.dig("result", "data")&.map { |item| item["tag"]&.tr("v", "") }
    end
  end

  auto_updates true
  depends_on macos: ">= :ventura"

  app "ChatWise.app"

  uninstall quit: "app.chatwise"

  zap trash: [
    "~/Library/Application Support/app.chatwise",
    "~/Library/Caches/app.chatwise",
    "~/Library/Saved Application State/app.chatwise.savedState",
    "~/Library/WebKit/app.chatwise",
  ]
end