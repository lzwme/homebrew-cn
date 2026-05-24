class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://ghfast.top/https://github.com/crate-ci/typos/archive/refs/tags/v1.46.3.tar.gz"
  sha256 "9c828f23640dd2c84b82cf1438a50714a851fe86706a183f92f2e1bef28a811d"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "080b6247145b6f4b7db753f31803cf4beccacd86f574507d17572da065a3ad3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3cddacb606ad7b3f5e2c2193f10a9c58ca15984a910258d133b36bae7d65be14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d3dc25e36dc5688bbbe608aaa9e1afbf9bdc5d9ed619e2e9c95f27d8bb42d57"
    sha256 cellar: :any_skip_relocation, sonoma:        "7787bfa005d87d939034f06bbb2deaf1bd5a0901f6b1bd2ed7ba4ee38cc18421"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6630e4cbf1c64cabab938f045c2316dabd6fdecdf37ef6879e0b65f7ab23c4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c6ec476d16e8d8f1e00f3a5d07e16aa4704910451f4b397aae31620594767d84"
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