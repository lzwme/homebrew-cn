class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.27.1.tar.gz"
  sha256 "dba9a5c11026a63ca4ae5f2bdcf3c491619f90d19629adcd27099008c371ed0e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cf70f503be9e4377282fb054ed4405198781498d1be2011dc13164c4fee6a430"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aac05176e443d4062acd1f9e86fa1765437b8447fb97fb9e28a4ba64270069a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "552bf78d9a18bfafd65c00ffaab3c13229fabfae37d6f7277e828b40b76fb551"
    sha256 cellar: :any_skip_relocation, sonoma:         "59bced4ac3a5a0b2c2fe3b26df1a9921e3f7a82b1a9a81449057ee5a26d08886"
    sha256 cellar: :any_skip_relocation, ventura:        "bfad165a2ddc7c1072e2dcbc99d1be362ed69f0cd8d30a62e7cd764012f1ad5a"
    sha256 cellar: :any_skip_relocation, monterey:       "92df23c0b1df50971420b36204a4b3eed3c50261163adb7e1f5b121ad2fd094e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2a85bdcafe35bf9a5801cca51be2d016b6c333a323336b51f705ea75611651e"
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