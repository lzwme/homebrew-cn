class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.28.0.tar.gz"
  sha256 "63b362d454aa37496c6d5eaebaee890b47b19809e3b0fb9f60efbbc97a713160"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2dab35085c0ad240ae876d79aba82f80139319435952dce0624ab85109f9742a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d2447da39467a8c41f16f3b8729308a47b58cee21d873395461690c358e3bfe4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "bf33683e10b2a2feeeed5ac807c93355591889b84219025e2c868ab0db0327cd"
    sha256 cellar: :any,                 arm64_linux:       "447df5d3affbd8ef850ea4c8f52dece3bcc908c1eedd7279dcd20e84aa83f29f"
    sha256 cellar: :any,                 x86_64_linux:      "2ef750a400ba5d0e7ded0f202649be6892ecc81f1a5c5efa7d12c81730701bd9"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm@11" => :build
  depends_on "rust" => :build
  uses_from_macos "python" => :build

  on_linux do
    depends_on "openssl@4"
  end

  def install
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4") if OS.linux?
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end