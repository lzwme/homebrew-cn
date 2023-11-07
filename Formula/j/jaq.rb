class Jaq < Formula
  desc "JQ clone focussed on correctness, speed, and simplicity"
  homepage "https://github.com/01mf02/jaq"
  url "https://ghproxy.com/https://github.com/01mf02/jaq/archive/refs/tags/v1.1.2.tar.gz"
  sha256 "26a4dd9b74a98f2c94283d3d0c8ec559ab2139a051997e0aa099cec5585e06bb"
  license "MIT"
  head "https://github.com/01mf02/jaq.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "025bf8f0012c9e512ab0caa981b793eed4928e8f6d1f93014b436819b9a4a0fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dcf0d7ce3cc52eadf77de15d1bedc612ae7e1879c94743cd2155b272dec8b1ac"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09fcf44245ce77d2992744b92e6cbeede933d8dab51051dc709724c57418781e"
    sha256 cellar: :any_skip_relocation, sonoma:         "69892e3c1444474da3a72f3c46dee95706123197848aaf4bbcbfee5a2e734c5e"
    sha256 cellar: :any_skip_relocation, ventura:        "e2b588fe76ecc06b2797839fe76b141f1d487c12e3937c051df30fd852d4006e"
    sha256 cellar: :any_skip_relocation, monterey:       "7f7d1a4dea5eef5551777387a770fc0553cc6e9ee2c2ea82c11c678a56a1c5f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a316de1f5e0cece48393fc865a261ec9666974a715e9e038ded15e38dc2467fa"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "jaq")
  end

  test do
    assert_match "1", shell_output("echo '{\"a\": 1, \"b\": 2}' | #{bin}/jaq '.a'")
    assert_match "2.5", shell_output("echo '1 2 3 4' | #{bin}/jaq -s 'add / length'")
  end
end