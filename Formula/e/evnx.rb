class Evnx < Formula
  desc "Comprehensive CLI tool for managing .env files"
  homepage "https://evnx.dev"
  url "https://ghfast.top/https://github.com/urwithajit9/evnx/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "838c5f1d63c1fe229c5507851ebf1756384b7230c52887bc88bbb32c6413eebd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "134fafb5576c79e6b158eb8963b1ff80ccab8016d0172ff8e3507c26d50db240"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9ecf6333a02de70b63bd6419f52830fe39deccfe367aa7f9cf2e5d8d56df2a11"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0787fe5215ce331c054c735c008f83fd1b0ee9f9124cd7fc2fe4e4c99aac58fe"
    sha256 cellar: :any,                 arm64_linux:       "1fca4d12d4e148e13764cc0b28b8f33d7f4ba076ac40ca33d177cf923a3fe92c"
    sha256 cellar: :any,                 x86_64_linux:      "102dfea9ef0a49c1daf0c1c61230b126d511cd32b29ea5837ac6c44d8ed07792"
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