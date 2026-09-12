class Juliaup < Formula
  desc "Julia installer and version multiplexer"
  homepage "https://github.com/JuliaLang/juliaup"
  url "https://ghfast.top/https://github.com/JuliaLang/juliaup/archive/refs/tags/v1.22.3.tar.gz"
  sha256 "74479b687a914db8c0b7e63c58babdf25f7dff4183d729f576b6e9d59dd30a8e"
  license "MIT"
  head "https://github.com/JuliaLang/juliaup.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8852032d09038ded8725df103f491bbc3cdedf78b87e8af986b9f451259f85d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "660455eea953c53291adb1c5b3886cf94721e82f6ebb8d45f1131c9ad1a0b558"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "072cb1540138c7c2e6f95ab2d4fdaf62baf7d04eecb73a0682b9b4bb1d7c7f16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "15eb9a5f851ab770002f05ca3d9a8591afa2ca170b005d8c7987209146b568a5"
    sha256 cellar: :any,                 arm64_linux:       "9a0845fbe62014edd5627fc8ad05e5b9739d8072afe4877d13ce0d7d2a08fe62"
    sha256 cellar: :any,                 x86_64_linux:      "5132e0f4ac6990ab33ffd995585681e681f78840056b8ecaaaceebe93c58f55d"
  end

  depends_on "rust" => :build

  conflicts_with "julia", because: "both install `julia` binaries"

  def install
    system "cargo", "install", "--bin", "juliaup", *std_cargo_args
    system "cargo", "install", "--bin", "julialauncher", *std_cargo_args(features: "binjulialauncher")

    bin.install_symlink "julialauncher" => "julia"

    generate_completions_from_executable(bin/"juliaup", "completions")
  end

  test do
    expected = "Default  Channel  Version  Update"
    assert_equal expected, shell_output("#{bin}/juliaup status").lines.first.strip
  end
end