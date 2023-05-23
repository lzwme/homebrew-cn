class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghproxy.com/https://github.com/crate-ci/typos/archive/refs/tags/v1.14.11.tar.gz"
  sha256 "d46d2c3819e252424337d6b3f1ee5eacb3c8a1465ffa5e58d8f1c8fefa8258b4"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c30d0c295dfcd444362f447de4340e98a88e2a1e17236a0c2c175d26f8460b4e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b2beb9df89bdf11a3c8dbccd17a4fc3cdd68f14040886ad1134e6a9f41cfb461"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b7a8c30530c7ebcf0e143e4c0c897e34201e41d6132882ff11e34239f7d1cb9"
    sha256 cellar: :any_skip_relocation, ventura:        "2fe6a88126503bf76dd2a1d775addc8184c5c3f1435001fcb49182322175bf98"
    sha256 cellar: :any_skip_relocation, monterey:       "90433fe90d7a2b75e24b298ba144cf05a6ee355a8e7ee502858a0f8b6f570b81"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d419feefc5b676fc76881d9498e06a79c2c5feff8ba4c8c9e8bfca76fb7145c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9e5de42e54f19dff786d2f59053f0742d8f6f112ce6715166427e07502c5d5a"
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