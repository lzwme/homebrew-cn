cask "comfyui" do
  version "0.4.41,250425eeib543v3"
  sha256 "48427a3d0afa588940250e1a82679b6dc5fc5d548924af96b95b433a77644444"

  url "https://download.todesktop.com/241012ess7yxs0e/ComfyUI%20#{version.csv.first}%20-%20Build%20#{version.csv.second}-arm64-mac.zip",
      verified: "download.todesktop.com/241012ess7yxs0e/"
  name "ComfyUI"
  desc "Node-based image, video and audio generator"
  homepage "https://www.comfy.org/"

  livecheck do
    url "https://download.todesktop.com/241012ess7yxs0e/latest-mac.yml"
    regex(/Build[ ._-]([^-]+)[._-]/i)
    strategy :electron_builder do |yaml, regex|
      yaml["files"]&.map do |item|
        match = item["url"]&.match(regex)
        next if match.blank?

        "#{yaml["version"]},#{match[1]}"
      end
    end
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :catalina"

  app "ComfyUI.app"

  zap trash: [
    "~/Library/Application Support/ComfyUI",
    "~/Library/Logs/ComfyUI",
  ]
end