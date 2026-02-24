class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.50.0.tar.gz"
  sha256 "0b3ca09780c4ed99fde0dce95c5a106496d9bf034c9755d1507688a577b17e48"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9dc3668af0e9c01e4c1e20b53050edb9d8a09f71c71a0c652c28c96fb3a1f56c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0bfec2af93741ac672e6f5c73884c70177a7cbd6361ee5d3e39ec1419f095a36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06b017485927328b17a78932ad3ca99bf64d337157b6dd917cce059c0f78c395"
    sha256 cellar: :any_skip_relocation, sonoma:        "3ceb9e86b8d939b8b4e10d956dd499730a59f8d900fcc2bd7043057a63ee93a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d24972cd38d75bc2dadda1357845664e672c22a717372e6c5f764a361af2a200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "584230735f2e7f4ec237357be461915c8a4cd23bc9a56c2043341b4faff55908"
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