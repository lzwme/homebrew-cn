class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.43.0.tar.gz"
  sha256 "bcf09fda2749b3df123d2a08877dc9b8a7f7e14e8153d5e623e8056378c7986d"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec544ed12d333b4b3481bd273731dc5386b500ed374657a67f95d8b179d3b044"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cc151226be3bbd9dbc1501d189d3cf52894a2585d335d0950d0ec7161e2a8e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "056ec0b9414bde3f4013d7de1664ccc9ad8b4fb09e25e2bcb6b011d6fbd258b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "777a3acf940a369b17dfe16d76c76c75061345064851400f781db1febb734cd1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "970c62fb8e4e9aae963d508c016108005a4196d16e30069ff6513ff1d88d9f23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6123e7b3c759b7f8203bc6af38ee8b9cc8bcd799ed0b60972b91c79d2b12d2"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "apps/oxlint")
  end

  test do
    (testpath/"test.js").write "const x = 1;"
    output = shell_output("#{bin}/oxlint test.js 2>&1")
    assert_match "eslint(no-unused-vars): Variable 'x' is declared but never used", output

    assert_match version.to_s, shell_output("#{bin}/oxlint --version")
  end
end