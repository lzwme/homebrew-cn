class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.9.0.tar.gz"
  sha256 "362af2401601387bba9b012797efdec76e92a92b514aa6b55a09a276bb0c9c7d"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c1a3f4c7c4035a83113cd8f66732511042ddc6eb3e810651f2d9b0f01f766b57"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94d91c65776af970ac6d0073c4ad778f5537d16e0cbba46ffef70c9c03a8fffc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bf6c9cf82976e93bb09c4a75b3874e11d61ce0c02936dbafe6614796446efb9"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc80657006e4ff8c1ab85297dc262683dcf992fff0a51060865c5081bfcf70f6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "39dfff7a83ae968f1e81344051f0cde5a6a3b10bf9b343f64aa12b5978b1d4ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7213661ba02aa4a5b9359f662b56863cabd51341a12c43679c5ee2fd37348ef2"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pay --version")

    expected = "no recognized payment protocol"
    assert_match expected, shell_output("#{bin}/pay --output=text fetch https://httpbin.org/status/402 2>&1")
  end
end