class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https://lib.rs/crates/dua-cli"
  url "https://ghfast.top/https://github.com/Byron/dua-cli/archive/refs/tags/v2.31.0.tar.gz"
  sha256 "e338d61af692898560851894fae4f26ba1435700b8871ee008e6c5b48bd0e34c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e5e448facbdb73ad0dbefb2a1f5ad4fcbfa463b0f4c7441303f9e7d4dcd62438"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f210e4c573704a85dd4573a6db70efdba16e683a8d16445504470c9d1e452d64"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c24a23289b629968ea4224a2b9cdc898a650d20e3b3729af922b538d79a878f6"
    sha256 cellar: :any_skip_relocation, sonoma:        "037c3b44cb73818344c6e051c9b4e60ad45ee65d32c77d9a2c2874532b2824e2"
    sha256 cellar: :any_skip_relocation, ventura:       "9ac8d73daec088f7caa1a5deb0e86d8b77cf965648c03d16398a5fde6130454b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20c6165d1f189e4cb5e3f9e7500a32c9b4b3519038ecbb3510b10bf4f136038e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "62f206214cee635064989b3de3f3b5c92b49e4923af2ad355474dc245c3f3c76"
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