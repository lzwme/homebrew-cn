cask "stability-matrix" do
  version "2.14.0"
  sha256 "c12b346f7aaadc16959aa42bf48b0616db655a5446f07e4ddcc654edf6d585fc"

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