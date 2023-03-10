class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.13.20.tar.gz"
  sha256 "bbaefc5a03bf16503e700d90466efed858102c858ded87b5c49c1a76b9b7d65b"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f257987c1bdba808020418508c6e328126eca500abec6203ba01871e5c1dae4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c47857dc81d808f598e25abb1c0b9b5253b6bbb8fa249e144a6528d219e0e996"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be16d0a15afd1501ac9c486bb564094da34c4ac556122d8e0bb6699711b3ce59"
    sha256 cellar: :any_skip_relocation, ventura:        "02dfa76b9250230496448db891558cb8d5630d683842d99921eeec9369b309ad"
    sha256 cellar: :any_skip_relocation, monterey:       "061c53b29cfbdbf1959fcc314aa4aabdca4e282f7492b7ef5656e5925c0b6f8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "52bbca7c4a626f76fbb86e00d70b21089a8bc156ef9ec8fd9349c8a2a04a67b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9222c9413da1dae515a4021afcaa2e1c7654bbb516598ac68ec7d5c283a769f8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end