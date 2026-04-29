class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://github.com/solana-foundation/pay"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.8.0.tar.gz"
  sha256 "0e1b4670831860666ae9d7963c70d98847909a27398eecbff071a7e0dc288025"
  license "Apache-2.0"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bddbc13ef9d1e31bec241e852acf761f832cb179f2a74d632287f029248b3f19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6267601b5a0164f1ac441bafe25acfeb27809108408a3915f7da59254c6390ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0bcc3b4beb395d2cf1bc4b8155264035669800abfc8a8d4142ffa2208423c2ed"
    sha256 cellar: :any_skip_relocation, sonoma:        "328c3dfdbfa6b6f401ef59347f27cc097504d30cb3e8b7a3c81a7122f9180e4c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8b9ef89da6dd68e8bcc0965001e63d022dfc9f5e41dbe9225264fdda98346a79"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc8d991cc57e0aba4e8931d4ee2c8fcd886867e45a1074497e8eec5c43f27b4c"
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