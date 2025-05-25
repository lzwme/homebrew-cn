cask "stability-matrix" do
  version "2.14.2"
  sha256 "0f9f8d85f0045040537b08e015924aae1e04c4f8d450630ef41ec000cdc1823f"

  url "https:github.comLykosAIStabilityMatrixreleasesdownloadv#{version}StabilityMatrix-macos-arm64.dmg"
  name "Stability Matrix"
  desc "Package manager and inference UI for Stable Diffusion"
  homepage "https:github.comLykosAIStabilityMatrix"

  livecheck do
    url "https:cdn.lykos.aiupdate-v3.json"
    strategy :json do |json|
      json.dig("updates", "stable", "macos-arm64", "version")
    end
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "Stability Matrix.app"

  zap trash: "~LibraryApplication SupportStabilityMatrix"
end