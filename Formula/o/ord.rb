class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://ghfast.top/https://github.com/ordinals/ord/archive/refs/tags/0.29.0.tar.gz"
  sha256 "94e86c8202d3fb660f494d33b79017d3226baa9d8f3a2e3147ced90189beede1"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e131d41ee5c39e38b38ddb3e47e41e18c4d4331b00c95131d3ec124fec26116e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "06ef5bbb1a9e32de8ea9a69df1181c5f42de45a615b25aa0f91b2d26b171a77b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "802e7b37429b98baf8327fb748f418c907af3b3f02ff64260ec52f14a0c89a5c"
    sha256 cellar: :any,                 arm64_linux:       "d9e6014f270bbf31307dc31f641ddbf180ee0aecea805a33b434b6f4f5830421"
    sha256 cellar: :any,                 x86_64_linux:      "5b748409062f1dd8e70f70d252fc3ed14e1ce4799d69284aeeb9f3d4e44bf091"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@4"
  end

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@4")

    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/ord list xx:xx 2>&1", 2)
    assert_match "invalid value 'xx:xx' for '<OUTPOINT>': error parsing TXID", output

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end