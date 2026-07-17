class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.22.0.tar.gz"
  sha256 "41de500523ad4f3ba218ff196a4ff4ad3b0834633f342d72b2854e72d9806cab"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7067b71d61b59cc82303ee21383827a8bd24b9f3565c83e0932d0035787777b6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e17e27fb0ebc87fd8ac63342c85a19b466d73be20c284b0b4cdf9d512bfab68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e39ea7e12b94c6bc3ca3aa308800ad035bc8474e2d08505b6bb6e3556bd43d71"
    sha256 cellar: :any_skip_relocation, sonoma:        "902ad5f7c68eb94aea6f5cb896ce2e8db814105715e90bb0159d8f0576c877c2"
    sha256 cellar: :any,                 arm64_linux:   "8dfd1747c3762b0ae5df009ccaec51cbdcf859db255dcc6aba4308a97b720b86"
    sha256 cellar: :any,                 x86_64_linux:  "d50b75273735cc2c3a34cf95ac034ed14a2832f542e29a42737c80b2437842da"
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