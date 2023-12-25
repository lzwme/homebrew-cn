class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.24.0.tar.gz"
  sha256 "017d213a96887b7d73115a7e020a4806dc4b3ab94f0df0268e11f2ce5378f496"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c7bb50d799698d3fc86c68ce1332526ba3752d6d99b1b627555594e8675a7a7a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95eb159c20743d14793feb86c6beb2b6373600f5593f23649047a92f974187b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fefe0170ae6f735b0566e0801ea347cba4d5e357d8ee5cdc7ef5f8b55e74dbd0"
    sha256 cellar: :any_skip_relocation, sonoma:         "1ad9e2766975491df9c9ba9f409e238800b0cc9796dde7935186ed7eebf7581f"
    sha256 cellar: :any_skip_relocation, ventura:        "f03c336e2edf2d9942e656da4c864bd423fbc52c3eb6465a0e11fee05a577421"
    sha256 cellar: :any_skip_relocation, monterey:       "c2fdb3d80bfcbd3e788df0287f6db554e294d2d2c1f5a5d34b424e7caa563b3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0aff33730c9ef2494737fc6d546844acea0dc8defee881bd5d5f54ffadb6a40"
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