class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.58.0.tar.gz"
  sha256 "49590614b091d94e90adf316fb8f51a27599fc9c26ad511b1836da6343ef08a8"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "015b9da8759f6777218c91f7bf9c4befa45de6ed576eb7e199e791740dadaca6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "514f64a12c6a2149ac9219dd369f2cd899150314ea0185b849faa470902030c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f957cef6d45e5a7b7f072ef66c3f7947f8177b1fa897a9b43d79e9ef52bd14dd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec0bceb2ec8f3eef28bcae48855538efffbe7d957973e200005514d3e1553710"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "407dd381c3b34041a6fe11de4e2102da91f12332a95b6e5516f7255bd381e321"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3aebca84fe0fecade238eb9273acbcdf582ef1d9cd8cddb720af2b97275ed0ba"
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