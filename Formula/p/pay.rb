class Pay < Formula
  desc "HTTP client that automatically handles 402 Payment Required"
  homepage "https://pay.sh"
  url "https://ghfast.top/https://github.com/solana-foundation/pay/archive/refs/tags/pay-v0.25.0.tar.gz"
  sha256 "eb24663f447857ea6ee2447b3f7bd7ebfd548da3a74761be7f128f26043ff394"
  license "MIT"
  head "https://github.com/solana-foundation/pay.git", branch: "main"

  livecheck do
    url :stable
    regex(/^pay[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d18c794fd4b60f174e3573e4a20e75157b3fff12cbe91693abec8ffb694ef8e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6cf3d9114c32fdbea4417ae542bdd7ceff4244019e344520dc28ca0b395cfaac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1bd3cb47476da8f79ff9083462dc11f605bf9b205a5afb943f07186a98487b37"
    sha256 cellar: :any_skip_relocation, sonoma:        "8b13393dba620a99248bbf11a24a2bd3a01dbd938b2c4308b907c376d007b9c3"
    sha256 cellar: :any,                 arm64_linux:   "b4f0d9585c2f33be086dd0bf77a497804df3df05455ddcd03deb6fbb94ca24e5"
    sha256 cellar: :any,                 x86_64_linux:  "33fe57d92d01eb0bd654804da561be0244d2c13cec89771489ec16e25c4b3d21"
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