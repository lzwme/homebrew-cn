class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.76.0.tar.gz"
  sha256 "7db154e9242c561603a2fe8dd00831993de2afc156927be7c5cd311840cb5069"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a4238853bcbca06c7a2d04b6e4d93f0d30a54f41faae73a53674aa583a73b1bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "898e2e43ba6cb92485eec20798ece2c08a86f693351c30c1286ba11378a1fe11"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "68c64b11e495da5f6e1b4c29d6a23152f7264d020527a25418a9a29c8eac0682"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7bafbce4ab5bd6cfbd5dad07766086c8a29709c2e2cbda248ac0e219f36050"
    sha256 cellar: :any,                 arm64_linux:   "65831216cf61fc129dac606575a2193bee878643c10f4fc027a23a71f33a0f98"
    sha256 cellar: :any,                 x86_64_linux:  "7aa31b70f38b4b5edf8944e6bbfe83b7875a6fc8a874d169dda62d767b43cf35"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars)::Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end