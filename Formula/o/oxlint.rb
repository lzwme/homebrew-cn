class Oxlint < Formula
  desc "High-performance linter for JavaScript and TypeScript written in Rust"
  homepage "https://oxc.rs/"
  url "https://ghfast.top/https://github.com/oxc-project/oxc/archive/refs/tags/oxlint_v1.42.0.tar.gz"
  sha256 "c394a3b0b2226e11b8b4af1829c441948cc56681d895255cc8ce29a6752849af"
  license "MIT"
  head "https://github.com/oxc-project/oxc.git", branch: "main"

  livecheck do
    url :stable
    regex(/^oxlint_v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f74b5482b1ed2414d375672067f9f931b932318dc20459de07737d19cfc947af"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0fc6193f95b35f9fda72ffedb75ebd4b64c6641722918f63ed889746fb198f71"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c4f9a02600e82de29c997254386010d12bf6f88579ac51308c89ded412f9a36"
    sha256 cellar: :any_skip_relocation, sonoma:        "c8e13ab839a0b72e6bc81deac4b1bf8c46eaac479d40f41b880de5108149dfd4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "698a3e7d6dadd6ff634c2dcfce943facb5a5c08a3083dc7050cfb5f6c415e536"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6757783485beb26b2d9378590566924db9b9a3a8ae56ba45b1e406e1a03ed7d9"
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