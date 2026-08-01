class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.40.0.tar.gz"
  sha256 "3e64699945bd7fd6ca6c6c0262618e0bf432c291b1bec2d7cb11ffb4df3f4792"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "946168421643123ffbda8ee6385194ec019cf5b25ae7ed3a0e922e29acc19c45"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9c9e65750452447acbd5d9c1c5d4e89032ae58618fd7e1b08a46c761b550651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5830ea5bd893c3e15627107b4d918197d50903e17162f7506222e746018b2f3e"
    sha256 cellar: :any_skip_relocation, sonoma:        "925238ecd11935ebb74360af3885314f4c59487236c9ee8b67f4a63dda8ec18d"
    sha256 cellar: :any,                 arm64_linux:   "04776d49bbf8a01fb241db5d4d26a2df549cbd942cd90d17bc7b1eff23b9e341"
    sha256 cellar: :any,                 x86_64_linux:  "e6f38e4d3c601c0296b8f251937cddfcc7136a3d86766ea7d39637d8820e6a42"
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