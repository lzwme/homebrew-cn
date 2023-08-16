class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.16.5.tar.gz"
  sha256 "627020a1844987d645f36ecd984fec4d74add9176b6bcf68f120d11ed2e9e73f"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1034439534890d816cc57d03a2192d2ec85267a1570c702d4558ebfc317128f2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7a918780c8da3c124cef57a5997d951cec1bd192d283ddc81377c0da8dcbf977"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86c4baf34ae3a64f83e18da8dc89a8cb2da6d4fdf76221b136a13f7ad79eecac"
    sha256 cellar: :any_skip_relocation, ventura:        "962943350fb2d26f871ed5d3adf5edf3e72fce8b0b13e18d3f30b95393855382"
    sha256 cellar: :any_skip_relocation, monterey:       "17b6630345b6a707c493b8660d51cc61f4351bd7c666739d89957fb4142935d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "bcdb2e91407b55a343c89b20e30cfe15236e8bd2510fde26d39d7f76d2dd6dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f9cf5040b2a0fdff4e8e9d4f0b683515dc11637fef796f037d792e9526c9e86"
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