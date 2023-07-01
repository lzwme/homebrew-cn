class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.15.9.tar.gz"
  sha256 "87b3cd1631388f65a09b02e549f34fdacdfa34a3cb7e6c7283876402a75d5d3e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b7709c8155370a5a463fef729b6d56a874561c8a98ed0a9dd7f5dcd66891983"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a82c80f5dd2de2188561eda1184a70e03e32acd984b10efcbe2d90070817e8a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ae255d0f96e4409584423abff5703766e7aebf0ff6e115911f05827a969df5ed"
    sha256 cellar: :any_skip_relocation, ventura:        "11a33e2132ff1bfc2c198ed6775be153c5a9e6a482fa0ab36257d64ae7185495"
    sha256 cellar: :any_skip_relocation, monterey:       "0874daf7e83f672f2f84e24566a686fa9461562b295bc368f4f73a900ba41e56"
    sha256 cellar: :any_skip_relocation, big_sur:        "94e1126f8d84f42558880ca8e69a99bfc441413234ceecf37707348e9441e502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c378fdb6fd366b9f17853b58e5a7ba172084051d7e221d27ef3104522778852e"
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