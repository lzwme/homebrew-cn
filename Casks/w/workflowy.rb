cask "workflowy" do
  version "4.0.2308290012"
  sha256 "d9d07ae60297259cb7ecd8ce6f599c1e5e7c93259dee9e682ddfcd3e7c58ecd6"

  url "https://ghproxy.com/https://github.com/workflowy/desktop/releases/download/v#{version}/WorkFlowy.zip",
      verified: "github.com/workflowy/desktop/"
  name "WorkFlowy"
  desc "Notetaking tool"
  homepage "https://workflowy.com/downloads/mac/"

  auto_updates true

  app "WorkFlowy.app"

  zap trash: [
    "~/Library/Application Support/WorkFlowy",
    "~/Library/Preferences/com.workflowy.desktop.plist",
    "~/Library/Saved Application State/com.workflowy.desktop.savedState",
  ]
end