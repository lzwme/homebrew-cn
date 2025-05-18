cask "stability-matrix" do
  version "2.14.1"
  sha256 "3275dcf62cfe40ffc14a88fbcaf0ad09a1ba98e29efc8195b3717b40c0044eb5"

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