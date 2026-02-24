class Llmfit < Formula
  desc "Find what models run on your hardware"
  homepage "https://github.com/AlexsJones/llmfit"
  url "https://ghfast.top/https://github.com/AlexsJones/llmfit/archive/refs/tags/v0.4.3.tar.gz"
  sha256 "6067e71bdee6953a7031775aa4fe9342bc5db0b974c413cdcefda37f39a3a2a3"
  license "MIT"
  head "https://github.com/AlexsJones/llmfit.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9d2958e1c94ded97751d7326e708ea50d2b739d587e94c7897f70aab1efcd54e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6853807f621f89f090e0facabb3fd5ca842e1cc03c909c7b1da90fb1fc594942"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6e151f6640f09a5be61af6ca57ee12bc8efe9380bc00871a61194009972375c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "73c12b4db835c302d90a370dde266259ab25dd4fa7356b1d517bd48ff301360f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7368e8503bd77a6b2b72235d7bc437632d18981fcad2af1359288a064010e896"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "56c0482472cebe2c91f96ea4df780d7797e540010d665d98662bed166994c858"
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