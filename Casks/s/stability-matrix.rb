cask "stability-matrix" do
  version "2.13.4"
  sha256 "65811e0fbb961cec0b74d3026eb8662f419abbba96ae7d665be610503d2afa96"

  url "https:github.comLykosAIStabilityMatrixreleasesdownloadv#{version}StabilityMatrix-macos-arm64.dmg"
  name "Stability Matrix"
  desc "Package manager and inference UI for Stable Diffusion"
  homepage "https:github.comLykosAIStabilityMatrix"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: ">= :big_sur"

  app "Stability Matrix.app"

  zap trash: "~LibraryApplication SupportStabilityMatrix"
end