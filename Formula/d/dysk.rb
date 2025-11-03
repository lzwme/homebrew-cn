class Dysk < Formula
  desc "Linux utility to get information on filesystems, like df but better"
  homepage "https://dystroy.org/dysk/"
  url "https://ghfast.top/https://github.com/Canop/dysk/archive/refs/tags/v3.3.0.tar.gz"
  sha256 "f40178720dcca0065542c7e07f08efee2c1a0a0abc4df24ca4bc681b89336f9b"
  license "MIT"
  head "https://github.com/Canop/dysk.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "13ec3a3485980d9da65f932b238b95b93ddb3a1df511d3ab320196a3015d2d63"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d6e489fc663e85d807177d721bce394ac59400d8d95def05633cb6ee2217dc74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "49ae9a3bd8896523b23c529f0bcb1ae626553c39bc1eba63e4af98ada1db9f97"
    sha256 cellar: :any_skip_relocation, sonoma:        "e28c635f3d759da6bc1b7b4c9c87610e226411a8682ff5dcb5b4a43aa57db048"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9376ad8b6749dc70d7f60ce1eb6b869ec5ac33c3e607b229ccad35c99ae6942a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fa5588ed626cdac0ed261a1f735b03cd256890a0d4d6ed64f39438cd82749014"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "filesystem", shell_output("#{bin}/dysk -s free-d")
    assert_match version.to_s, shell_output("#{bin}/dysk --version")
  end
end