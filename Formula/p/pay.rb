class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.1.0.tar.gz"
  sha256 "d2287646252fd8f24d628963b2c8b36ede2203d1d107aa2283c8dc98c1c65567"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33d4228674d3300180b912bb6926bdb597cfb8a4bad5163ab11f2dc9b7c67c9b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f619a56e0b1b306aa325efdd870963926f1ca3587a9e71bbb22dda86b7ddaa36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "06e7179dc4f7d90fc44663f2a4976d59a82af42d1ea6f9c1680ea85846c61d53"
    sha256 cellar: :any_skip_relocation, sonoma:        "c5215f16afbdeabac41a3415bc41026920b263e0f7db24735573c2119bed962a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bfac7996e30d19e40b39eb7b2c222161956d5b9633b99f351cc316f76927756"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "368336f2edaaa44339cf4517e62450ee81189e0be7ab33e8668c989e51f00f3b"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match "No wallet configured", shell_output("#{bin}/pay fetch https://httpbin.org/get 2>&1", 1)
  end
end