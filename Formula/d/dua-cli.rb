class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghproxy.com/https://github.com/Byron/dua-cli/archive/refs/tags/v2.20.3.tar.gz"
  sha256 "b526c8c43853943f025ba36bf7297fbd9b1beb395ad92e70c41fed7d8d584be7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d81afd1849b28bd4e41bdba6a0a714f1514f13769c60126870ec816c94d2140"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0de314c9094b8613907ba5667ccbcb4bfda22fc6e0debb8cc5323a6f4faa1bf7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a3eedda2f9bd140c155e2a22fb20b2536c883e0aac93fe75bb86de90086c487"
    sha256 cellar: :any_skip_relocation, sonoma:         "4b7aa815b0763d27167e4e5f386ff19549bb86b69d77a868ec23a2291c0b321a"
    sha256 cellar: :any_skip_relocation, ventura:        "e90a7437bef1c3e57660fc98319134fb2cc58de38ebc5350d2465d1ceee667fc"
    sha256 cellar: :any_skip_relocation, monterey:       "5ec3d625018f756b9441a5219c4300ef2402879a04c6b80fc9cbd3fa1884eb8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a0deb21aa58962188f750ebf6087e6c20d5ec679446d916ad3dc1ec705b60533"
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