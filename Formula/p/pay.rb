class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.24.0.tar.gz"
  sha256 "e454514882d27dc23d7178fdb69a1a57dd4174d7693d3613acafdc5ba43bc2de"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d3674d2732c302afd2584b4afe9e4d8626cc7deec28e36293c158f65f994f6b9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7209e9751aef20da4624ef8ffb01917f0e808044fdd0f608ec96c3199d82190"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca627f3e619b4b677a0dccbbef042088732ab2b4d9ce5225582665f01c187086"
    sha256 cellar: :any_skip_relocation, sonoma:        "e8f5c98a32645263dc20c43da7667fd73af4d49b515a7850317c806685113aad"
    sha256 cellar: :any,                 arm64_linux:   "f9c8e6c200226c9a1da79d56fa54bf1c8d00282f4018c892e1c48d6677ff1ab2"
    sha256 cellar: :any,                 x86_64_linux:  "f7f165f1ad81dbf98db0c733be153bc615ac71a41fc9a863c481393b014685eb"
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