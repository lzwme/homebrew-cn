class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.39.1.tar.gz"
  sha256 "dfa2918a5d21cdfa355d324f3d5ac92bb0d1445ef813218ea2d2ea3a36a819b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5cb8cac866eb88f955d2f5b7339f33205d55718339c72443678dca910b0cc496"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05a53bc04400ec4e25f960ba4e947c3e32a5293484a904a81c9db8429e6313dc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "48108d31445099e9f1797ecbe981c6c1b41e7b92b3e759543b149e11b3fc57fc"
    sha256 cellar: :any_skip_relocation, sonoma:        "ed6f4b8b35836dc032a2eca3a22638eb607b31c1394ab140adc0d87771c21836"
    sha256 cellar: :any,                 arm64_linux:   "83e30c8c35b1c8122a7d08be9f43332a97fbf5d3c6d73fee8a4374e20a961c4a"
    sha256 cellar: :any,                 x86_64_linux:  "ea18d0c4446996c4643dede14774fdb34fb5f10803b344b1147ececa93bf3c27"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath/"empty.txt").write("")
    (testpath/"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}/empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}/file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}/dua -A #{testpath}/*.txt")
  end
end