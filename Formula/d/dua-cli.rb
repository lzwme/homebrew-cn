class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.25.0.tar.gz"
  sha256 "4b173266831c8aed80a3fb2ac418cc33057f9226b70a831372c8d4f0712b80aa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11fd3d54791f2e411b0b80b4e9aedf461a2f6f0ee18d3aa2e67cb51a2fcc7ee0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f27d40a844f27ed7ad8ae2d59a685c0d77c92805d3cdd15db46ee45244f5af7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "87c77ed8e945a339f2be08b6a6fa9ff6484a1e558e650bb2061c1cc02d4ec9e0"
    sha256 cellar: :any_skip_relocation, sonoma:         "21a8119da7c22d0338f2b31222e051c6eedfd151d713227cc90e42a7e85309c1"
    sha256 cellar: :any_skip_relocation, ventura:        "ed4199a5f58d5d93e874679763ea2da241f900c2cd5ac17738abfb94d3ecb02c"
    sha256 cellar: :any_skip_relocation, monterey:       "b1a903572fe327359ba84007976239d3431cd8b4d44ab1a9abf280184ee0de54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a58c12fe079bc4fcbdb6617861e4b50bc1474232a5b41bac8f2b67c031ce9a6"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Test that usage is correct for these 2 files.
    (testpath"empty.txt").write("")
    (testpath"file.txt").write("01")

    expected = %r{
      \e\[32m\s*0\s*B\e\[39m\ #{testpath}empty.txt\n
      \e\[32m\s*2\s*B\e\[39m\ #{testpath}file.txt\n
      \e\[32m\s*2\s*B\e\[39m\ total\n
    }x
    assert_match expected, shell_output("#{bin}dua -A #{testpath}*.txt")
  end
end