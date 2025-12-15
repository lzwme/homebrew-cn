class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://ghfast.top/https://github.com/ast-grep/ast-grep/archive/refs/tags/0.40.2.tar.gz"
  sha256 "7bc1e88f40f0ff3971647bb39e2542f3f68cdbe0a73ed9c384aa21276bcbbbfc"
  license "MIT"
  head "https://github.com/ast-grep/ast-grep.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b2476019088f4879ed8bdee5fae36fd75213e2fe85e9af4e189d840f89003daf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "598da7c89f194ff1406f6da8912a6caa7bff6bcf0f1aa2485394bc30e0b071d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6c2dfec71ccbc53c53d85df198cdf47ca30c91df892ea0eda0485f622216c164"
    sha256 cellar: :any_skip_relocation, sonoma:        "05cccd6bce54d4883d268718bdaba0fe4e8a4e70a5b75183f622dfb6d3596b7a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07791a26d0b8b323111bf90c1468f2dcdc78471b20eacfa8539ba7e42466ba75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368b154657c0f2a24dc5eb030cfc1a5a5425db67fc5115a95c074ee5f7debe03"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")

    generate_completions_from_executable(bin/"ast-grep", "completions")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system bin/"ast-grep", "run", "-l", "js", "-p console.log", (testpath/"hi.js")

    assert_match version.to_s, shell_output("#{bin}/ast-grep --version")
  end
end