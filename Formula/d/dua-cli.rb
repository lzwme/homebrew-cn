class DuaCli < Formula
  desc "View disk space usage and delete unwanted data, fast"
  homepage "https:lib.rscratesdua-cli"
  url "https:github.comByrondua-cliarchiverefstagsv2.26.0.tar.gz"
  sha256 "45605f86655059ccb4b4bd6e5fe37275899b6d6eee5344fd63b4b2a32f00a182"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "91ba236c39877e92235212a7496579bf7708447aad97d3cb72483e92f78f5266"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "547f20b82b79af41fcaa5dece7720981b91fd01eda9055396d7e8c7b4768056e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04a1aac3ece144ed564b9b39f68beb841b745ea037fe2d8bbfb51ee9bd072529"
    sha256 cellar: :any_skip_relocation, sonoma:         "5a1b7e96c9672e565870373a159f68906c985af2a09a7b0a96050c4d15aae5c7"
    sha256 cellar: :any_skip_relocation, ventura:        "ca7c2661d1ffd114ffd9b82b30fa053ddaf05740962bccfbcf828ff5531e3e68"
    sha256 cellar: :any_skip_relocation, monterey:       "799fdb527b172bb7f0432296c9bfad14ace9e91730077c22b14eadedc3beb39d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fbf541c0dd188c90a894620e47745ffbb92293961c4b00b91ec16a774e38953"
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