class Splitrail < Formula
  desc "Real-time token usage tracker and cost monitor for CLI coding agents"
  homepage "https://splitrail.dev/"
  url "https://ghfast.top/https://github.com/Piebald-AI/splitrail/archive/refs/tags/v3.7.0.tar.gz"
  sha256 "f87fa59f66d6b4cd97413d42b773c49ae35a88edde3e976714517eff9d789623"
  license "MIT"
  head "https://github.com/Piebald-AI/splitrail.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4d5b498a06c2ccc7f53bd6bb9ce6741cbdcf863dc89b42494eddd5d35a18e375"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d203d66c298de1da75009c365ecf9b42c2433a5a847c4c7a6a370379dc45e83c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "24a1610f58b59f724d3f8be9e32aeadaf79334621f85540f77ae25219cc66349"
    sha256 cellar: :any_skip_relocation, sonoma:        "63e59cdd6c63a74824949d404142854787522492b0234dfae6359bac40017f38"
    sha256 cellar: :any,                 arm64_linux:   "c12a5c3717c54303e204dc0071e6f3f1fdce3d37469d7bd7d840d843c27af01e"
    sha256 cellar: :any,                 x86_64_linux:  "f5b4532d0e72de7767085dc4869f08e75420b82dd56339074e5f30b210a52ef0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/splitrail --version")

    output = shell_output("#{bin}/splitrail config init")
    assert_match "Created default configuration file", output
    assert_match "[server]", (testpath/".splitrail.toml").read
  end
end