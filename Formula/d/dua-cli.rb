class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.24.1.tar.gz"
  sha256 "35dda26db76211af8b7a498290f04f3b7c577cfef36d48e447abf983b910f678"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "581cf39eb89dd919740c20f2b3900977e3c4ee64dc52a649e3812aeaef40367e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "73c79420cc2df49a82047d59b8734bd56159b364abca090504d8363ec06cff1d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "904b30f43b5bebc35f6f9997ffe7bf754c6a6c8d75b8e739970f7300bb337b6e"
    sha256 cellar: :any_skip_relocation, sonoma:         "412b6e23e0f9f8855371e883e06433390ee2e86ef264ba8bd9f55ad743fc5bc2"
    sha256 cellar: :any_skip_relocation, ventura:        "925d7a771019bd37cf98cf7fadb165fe4191848c7d1f54f441c2170a20d3d7d3"
    sha256 cellar: :any_skip_relocation, monterey:       "587968f26263334bf7fdf25da8cab62fe5c2e9e19d9f34e83c6596f29c100844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b25f2d57ae980217e6663c64790aaef8f77f3b58c4178e390c332c70cd4ba23"
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