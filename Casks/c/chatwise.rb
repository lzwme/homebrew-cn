cask "chatwise" do
  arch arm: "arm64", intel: "x64"

  version "26.4.18"
  sha256 arm:   "c7f074829b996095df1a0905f05570da96e883ccf0b5d4082985f2f54e2a666d",
         intel: "8b64e4e845696dd5b6f70343a7df2a092ad624fe4b3f8ac2bbba2a3a26957b14"

  url "https://releases.chatwise.app/#{version}/ChatWise-#{version}-#{arch}.dmg"
  name "ChatWise"
  desc "AI chatbot for many LLMs"
  homepage "https://chatwise.app/"

  livecheck do
    url "https://releases.chatwise.app/releases"
    strategy :json do |json|
      json.map { |v| v["version"] }
    end
  end

  auto_updates true
  depends_on macos: ">= :monterey"

  app "ChatWise.app"

  uninstall quit: "app.chatwise"

  zap trash: [
    "~/Library/Application Support/app.chatwise",
    "~/Library/Caches/app.chatwise",
    "~/Library/Saved Application State/app.chatwise.savedState",
    "~/Library/WebKit/app.chatwise",
  ]
end