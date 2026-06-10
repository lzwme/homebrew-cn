class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.18.0.tar.gz"
  sha256 "20fbc747bd56274324fd2e03b6937dc2c80c6ab4ee01cd6f38ad5ad0f92ec2a3"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "486cbf11eca39ff9d18e9e58c5a3f5865fdc8bef79bb3cde9279aa5d883072db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9c974ad050176c87b079e85b1304c6db3f16f5f9e4cd47b1bd3a8fe69f29678b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4831ea76acab32f6be042d923da9d8d2d028590c4bd438e0d5d0636d7f019806"
    sha256 cellar: :any_skip_relocation, sonoma:        "c07a30614b0f96f7061bae85f4baaf9678be42e01f4e88eed937cbe59ff8bab5"
    sha256 cellar: :any,                 arm64_linux:   "a823eea8e53b10bacff0b63a20c3023b71070c2cb8898c48f94ea17a085dfb1d"
    sha256 cellar: :any,                 x86_64_linux:  "c6fb59ed1a157deda95380fd10a099d53242003943179200d6082d4fe02004f5"
  end

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