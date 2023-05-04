class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.14.9.tar.gz"
  sha256 "d4b3bb692edd86f6d01efb5e3c6f1db1882470e2f6ab5f45245c131077b42397"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7230df2216090002732ba79484cdd1194d3330cef530f58612fe2803e7c63c3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35db05636933886ec1d3f60c9b2dc148f1555cf2933a466e941e9b3b6996c521"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3d3da5ca65acce5d5463a2f94b1afbed7a5754f8753bb7afe958582803e0338"
    sha256 cellar: :any_skip_relocation, ventura:        "136f8e51cfb2c0d452bfcee45bf41325e281c0fb8c1e5d7cdc00ab97b241ca9c"
    sha256 cellar: :any_skip_relocation, monterey:       "c51d7dc448411229853a7ca35029c342a83c93cfe14e5831a303dfbda4b0a76f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b99f4fb17858a34b39d77096aa6cb5c00532fd436b52c0389ba6aa4a8d8ffbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6405f77bb941a2e7a8889867cb510c21ff949919c0cc9367a41f128c0408484f"
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