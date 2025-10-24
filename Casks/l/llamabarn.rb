cask "llamabarn" do
  version "0.9.0"
  sha256 "6a42fb1086946e28e9ac9ef03ebf0152bd53a5457d73bda53e53cf8a3f4679ba"

  url "https://ghfast.top/https://github.com/ggml-org/LlamaBarn/releases/download/#{version}/LlamaBarn.dmg"
  name "LlamaBarn"
  desc "Menu bar app for running local LLMs"
  homepage "https://github.com/ggml-org/LlamaBarn"

  depends_on macos: ">= :sequoia"

  app "LlamaBarn.app"

  zap trash: "~/Library/Application Support/LlamaBarn"
end