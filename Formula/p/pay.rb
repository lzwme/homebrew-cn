class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.26.0.tar.gz"
  sha256 "8f1354c8de8bbbbd6499991063e3e9cff150c04e0eb4718a9440f30394c4c346"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a6ce7e2045e89ab132f59bf81646f8f8c49d301ca74c197078fdf8af4129c16e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3da41418fe1abb0cc4abd1ae400883a3b1d48a62f09679bd0200c96018bda2d0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "728eb0dfebd01c2c05d0dbfe46c36c87a17c29fab5d53a4d7961381db8609c7a"
    sha256 cellar: :any_skip_relocation, sonoma:        "c55db248ea15bc94e2624cb9f401cd4222d93e8487012f27aed4544bd42ddd95"
    sha256 cellar: :any,                 arm64_linux:   "4a0ca2d4f2ca61739f4297564084f15da3095d8b288e6046ff6181e56d6fbf1a"
    sha256 cellar: :any,                 x86_64_linux:  "ab7f8d2e4a91bc62cec6e3f496a6d58fefccf2ac749816e34ca21d8f5e6884fd"
  end

  depends_on "cmake" => :build
  depends_on "just" => :build
  depends_on "node" => :build
  depends_on "pkgconf" => :build
  depends_on "pnpm" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "python"

  def install
    system "just", "install", "pay", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "No pay account configured"
    assert_match expected, shell_output("#{bin}/pay --no-dna fetch https://httpbin.org/status/402 2>&1", 1)
  end
end