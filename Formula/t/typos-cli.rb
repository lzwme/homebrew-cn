class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.49.1.tar.gz"
  sha256 "cf03f43496e14c4925969aa5d583c02db74ea2711895d26cf0df0cdbb571ed7d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8ee87613e7f3c979036b133e0b63f5982e93b6dec722adc4608f4e55328fedee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fab4cb3e599b6ae1fc3f1ffe2dcccc1193842427bb9850b46ccd8ec6ee57148b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1890f5b417a387d1cf33511c3ea26ffabe64f0111f2317d51ce2028db9ceb627"
    sha256 cellar: :any,                 arm64_linux:   "73a73fbab87efe43670e2daa0a24973be295bcfa42b3c12b0eb5992edf98a429"
    sha256 cellar: :any,                 x86_64_linux:  "4a63685ca2a4eff23174f77bd629c019af327de8a83915dd9e914cf4afa97fee"
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