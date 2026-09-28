class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "5d506f204e0745f2aadaba7a83c0342e89eb504b75332128f59f64f5e7b8638b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "82c0f43588baa4efb114c581bdbb312d52ae8af1cba187d7ac533ee6cf7b4b2c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fd7c9b4b40f4b2fadff6708cd3e55a9cc76e6118b392613a98fa92db74b73db3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4d21be93deef32a13f0ec6cb091218821a862af47b1749149e289d665dbfe2b9"
    sha256 cellar: :any,                 arm64_linux:       "058380bae5f26792b9510197db5674430a860f6892638f72491cb2db6b8ac55b"
    sha256 cellar: :any,                 x86_64_linux:      "e5a58178030f1a8930419bef070e5a2d9bf3b9ef17d3a1c868ae48354be9847d"
  end

  depends_on "rust" => :build

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evnx --version")

    system bin/"evnx", "init", "--yes"
    assert_path_exists testpath/".env"
    assert_match "All checks passed", shell_output("#{bin}/evnx validate")

    (testpath/".env.example").append_lines "API_KEY="
    assert_match "Validation failed", shell_output("#{bin}/evnx validate 2>&1", 1)
  end
end