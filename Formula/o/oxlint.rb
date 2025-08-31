class Oxlint < Formula
  desc "Suite of high-performance tools for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.14.0.tar.gz"
  sha256 "90633186dcf4f3f3aa8c2a1308b9ed6ec9b5def6ef68a6abdbfa283d9098f433"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dd7046510499312c7cc0b42af142e6d5e13d3ad3604c23c4c3f1e96510b947cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ff4f1314ff24930904abe730e7350464803e4c751b3e3c658d574502b616fc46"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd38e9c76f271d9656b9ec174fa6fd81ffd01846abe5070cf87e6587629bde55"
    sha256 cellar: :any_skip_relocation, sonoma:        "2014694e8791866e38c63eda46907764bb0217c4ae5538edf1b1cda3b79f6f23"
    sha256 cellar: :any_skip_relocation, ventura:       "ae27416ef2c88864bc613001710dcd18c4e04ca48759be775e18e88c95c3992e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ed0640cc47a81b59e879c2d696ce94a7a756770e8f33eb383413ded8e2bb9b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e39a7fe64134aaab2ef6af0f0e2cf53c695d43e81c7bb6f6913284f66f7184f"
  end

  depends_on "rust" => :build

  def install
    ENV["OXC_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end