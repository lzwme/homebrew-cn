cask "chatwise" do
  arch arm: "aarch64", intel: "x64"

  version "0.10.5"
  sha256 arm:   "414c87c7908d288e47029084d8134cbee567d567e7d6d95732f7fa279ec07dca",
         intel: "157cce47987a1a9e7d6b4c77750e75193dc97612f5a84c2e2f0ced5c3530dbf0"

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