class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.7.3.tar.gz"
  sha256 "959db9d062fd2f637a1f669a106e96c3c432c9a25a675753e5b39cce73b2802b"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b7baceffb0e4e79aeae4171e507e76f90ef2a68f5303848c32a1d3236d292f0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42edf8f49e4ca8bf15deef43e61e4d9016420aa574e07f55519550dd722ba3c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "552953dd138e78eedc5e2b53471ee974957c3d7246f56b0a7c330cba660953aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "07e6b65407beb10b07c68e265eceadc10e51454d44c4e5778d2098e523ebbd1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9956a58a811d415bd1b501f590cf3cc84ba8634b9e0432bcc7b2822c867effb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "707fc0d76bf31c1657279b0fd0c9d1fc55c8cbcadc013473e78777c70ec69a75"
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