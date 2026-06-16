class Ccusage < Formula
  desc "CLI tool for analyzing Claude Code usage from local JSONL files"
  homepage "https://github.com/ryoppippi/ccusage"
  url "https://ghfast.top/https://github.com/ryoppippi/ccusage/archive/refs/tags/v20.0.13.tar.gz"
  sha256 "9e0924af376b97c899863ef0ca2827f9b3fb6c13dba37ec3bcb9e247170a207a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b9e57b81fdc69346c2e82000b248ac6fb950a791afba0b6e04cafe99b9bb9c3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5b71a5913cb7a805a6d9021378e554f152ba700293e13c5158d8855c0598fd52"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4586302b602e76d3a1b041c340989e64b6ba6becc7225bee8f55e76e58afb081"
    sha256 cellar: :any_skip_relocation, sonoma:        "14100a519e41ea5823ba017535cd584caaf06694fab60e1a9aa122ceb6c2c2a1"
    sha256 cellar: :any,                 arm64_linux:   "53c91203bfa74611368b6a42d647d6445c2d3b5bf59473c558a9566435acf14e"
    sha256 cellar: :any,                 x86_64_linux:  "044863aaac7faf38067bfd7c607b459ca279e61b3ecf301022fe709e46c29b24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "rust/crates/ccusage")
  end

  test do
    assert_match "No usage data found.", shell_output("#{bin}/ccusage 2>&1")
  end
end