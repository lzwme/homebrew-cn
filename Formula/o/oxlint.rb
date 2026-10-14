class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.88.0.tar.gz"
  sha256 "6b888d409e238317edf339e037dd917575396e7406ece048866c7b7854d4e1e1"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "fcecb46fed794fde9286744547a783c07b674e94066bd96ea85dc91991beab95"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6bcdff9d602e49628756b3b49d229611cc85704fc14bf45b045e47327fff149f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "09f5a3198c8710825a3efb4040f07be73a20dcb7332ac0780fc8daf3d7594fc2"
    sha256 cellar: :any,                 arm64_linux:       "79b70170cba7569c2291c96fcb87e024da7532b8eda5c1bed3b073ed0c7f8da2"
    sha256 cellar: :any,                 x86_64_linux:      "2f097268e4492856648436dda997c668617f93b77646fa7fbe9877a345c14794"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end