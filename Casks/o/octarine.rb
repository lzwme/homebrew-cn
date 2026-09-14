cask "octarine" do
  arch arm: "aarch64", intel: "x64"
  folder = on_arch_conditional arm: "arm", intel: "intel"

  version "0.52.0"
  sha256 arm:   "8103a01d6666620ee13fd5212584a568cbf2669bb5b719363a1355b30f143199",
         intel: "af3136530b687b5da2ed7a052e2cb39739dccd5626fc0428f034ffcf4eac2527"

  url "https://pub-3d35bc018fc54f11bde129e3e73e8002.r2.dev/#{version}/#{folder}/octarine_#{version}_#{arch}.dmg"
  name "Octarine"
  desc "Markdown-based note-taking app"
  homepage "https://octarine.app/"

  livecheck do
    url "https://octarine.app/releases"
    regex(/href=.*?octarine[._-]v?(\d+(?:\.\d+)+)[._-]#{arch}\.dmg/i)
  end

  depends_on :macos

  app "Octarine.app"

  zap trash: [
    "~/Library/Application Support/Octarine",
    "~/Library/Caches/Octarine",
    "~/Library/Preferences/Octarine.plist",
    "~/Library/Saved Application State/Octarine.savedState",
    "~/Library/WebKit/Octarine",
  ]
end