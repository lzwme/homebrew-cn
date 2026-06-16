class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.70.0.tar.gz"
  sha256 "c0115773b4c879495f0bffa09347b4ebdd15bfa8f671b8d6efde82ce0325b7ca"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a00c128dd75b7931b866d10dc18597894056ca9ea1daa47d71df41e13436d91a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e8f7a4859ca4e9c8a5eee3b0c197f0b7cbbfd4276bf9153aba37192eb3e22f7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b0814a24133da8215a120f0e5484aba9fab6dcf1a788e6084610cc3d3a655bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "48e1b528304f3a32a7dd6d78f0cef41e17c04c3803b7ccab17a3a7098166bc96"
    sha256 cellar: :any,                 arm64_linux:   "31e80aebfd0a121e7f854b4060f258e0c7abb68322e9be3996c5df229af28aac"
    sha256 cellar: :any,                 x86_64_linux:  "b9905c53053595029f7b7206a2ad36733aabef4d5c9b64a5ccf13bb3b7bbac03"
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