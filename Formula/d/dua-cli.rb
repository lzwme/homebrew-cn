class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.23.0.tar.gz"
  sha256 "61f6fd0c13949d23224d9776c2fd444956d73dd363501e867cf11df6ca89ddfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5a7a98565d85281221b29f34dfc05edbbd75e9b4eac203762afe296c75de73fa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c3b6fad8680a5ef1c735009a42872eb3ed34ee1e6e84271a60ce78cfafaba22"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1a2c84d9c0d5bf2bc1004d4f05a0cb39ef8eaa7c4f16918a3fcd3c2c09fdf4b5"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f2221f3c343910842eb9f24fd6789d8db91c14cf01e5838cd71dc1e40979370"
    sha256 cellar: :any_skip_relocation, ventura:        "5f0ddca9c87c533899698a28f44e2d9e11f3d1979a004eb47116664a05c3ce06"
    sha256 cellar: :any_skip_relocation, monterey:       "48b9f88b90b2e1ec5ec41807c0c0a8921482fddafe443e13b687bd49a5f3607b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91bbdacbaeef1ff5c24d9b4b8f5b772556aa8fcfd3eec955ee632af61b279322"
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