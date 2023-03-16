class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.13.24.tar.gz"
  sha256 "44ce214ee9ec4f6921fd7e713ed9e351e7b793e73a675e6a2026ec769cb94efb"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4e0474af5725bb51266a98228d1caafb0b2d0294e6a7f2d5a13bc6852eb9e3af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f68c30358b03c8981dd43ec4999a3d9e6b97488fac4b2d9b09063ff7b273a87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8a6614d7fd7e225093592c79995a7c7dab84aaafce155e8a17a595a6225bf6df"
    sha256 cellar: :any_skip_relocation, ventura:        "4e7f25912212af6f7dc4008ea7f889a0eeeb73f4fe37001dff12b86cbe422f57"
    sha256 cellar: :any_skip_relocation, monterey:       "4fb4fb67e40e6784fb6ad0db865fff0862dc0112c883c8b078367354eb39b580"
    sha256 cellar: :any_skip_relocation, big_sur:        "b424515ebb2cbd853d0083b65b13c9072880dca6f49a98396ef957cdf107c5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f96acd66d1e9dbe119b6f88c47a31d3387104f3ac78cb3b760c26372682ba9c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/typos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end