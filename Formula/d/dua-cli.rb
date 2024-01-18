class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.27.0.tar.gz"
  sha256 "505f41f9628a5a305d9f713da4adbe972fdf40fb810b327a6fb5dcd3998c7bd5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75fbfc2f4a21af911b8a04e7a1504ce37a603de8b7a5552035432c76efa5385f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "df6bca7408705122fb2f8066cfb8230c2b32c77ea009b6d0abc8cbdbacaad43c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1d2dd16de4e5f4ac218cd3c5e02641d5670c467e2a03b4d9b1130b5c67f8d6b"
    sha256 cellar: :any_skip_relocation, sonoma:         "da62cb3d69817b263e332f6a7ac18145bb71725a266184a1542ac901181b84c2"
    sha256 cellar: :any_skip_relocation, ventura:        "1c7bb82c11374c5e1d3c7052a4c216d3930920c0cf0c4f114c6a3fb746070eb2"
    sha256 cellar: :any_skip_relocation, monterey:       "0c4658bb8a0dda579c3f75fdf9b83a0e688932c02a3763778592594942e8bc2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d38f826789965e576bbf8213ae424422abedd0e494566802eb725946eb3393ea"
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