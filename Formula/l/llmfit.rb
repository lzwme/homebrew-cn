class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.7.4.tar.gz"
  sha256 "87f868eece56e155b75403638a2fc3d3981be6efb567f63d3ea881c7806731fd"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "25d42873845920e843a1aa0a27a24c87db65921bf1e8360f7c19ee4f91e3dc34"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "100d8a510cebaff19c136188f7f232c3a7f3a95dee05726572e94b4939347d00"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "eef7539c9a0259f0d018c51cf63889e1617261644e2db7a6d1d5225c60b1d7ac"
    sha256 cellar: :any_skip_relocation, sonoma:        "b0f3bea5ab444e1827fc10db3f5bfaed7057d97ad44f0677f7453583d14a3c15"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c0194242463ce7cfc26cf086b39a1d4dfdb54d24eaed5b60b68376187cf08e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f63a73a762355d16ea57a49087339ab93f8934a18d6d269f3eb007608aeac62"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "llmfit-tui")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/llmfit --version")
    assert_match "Multiple models found", shell_output("#{bin}/llmfit info llama")
  end
end