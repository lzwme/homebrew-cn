cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.9.1"
  sha256 arm:   "61595f0a9fb11b3a8954ed7865c72aacad97d051c2e8b8425fe60fce4c5106af",
         intel: "a715f48431d642ca8d1c6fcb7165245aa63368a8811fbcbbe17622b0025a1241"

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