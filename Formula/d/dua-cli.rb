class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.27.2.tar.gz"
  sha256 "327ddececb404e42fd0524caa0f2808eff08888ac53086957c1a41160d3a6f20"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "81b1260458bb72418b7cabb53b0e06810b76ccab7923a871fea37a9f9728a54c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70fce5ab83e40ab7fe521c8bbcd9605e8b10bc28940d669155c848c6a31c08b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "491d37ef40421229fa09703f8a732b6056fae03a0e55884ae739d2359b66503c"
    sha256 cellar: :any_skip_relocation, sonoma:         "17f7ca936b36827ae225e48a3b858d2df0bcc47a31740831fe53feb10d43bcaf"
    sha256 cellar: :any_skip_relocation, ventura:        "df33f1eb34109e4a19f9f6debc74f907980c36758fc0a8d2961433908b1407e6"
    sha256 cellar: :any_skip_relocation, monterey:       "a18d57be6091c406b50f5607be3523f3e3fe83ef0fe3d9799786b045628abb94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce287a47b4155693d183eeaf7f7f302cdfd77493e68d3ca42edd06789145311"
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