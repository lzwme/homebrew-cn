class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://ghproxy.com/https://github.com/shenwei356/csvtk/archive/refs/tags/v0.26.0.tar.gz"
  sha256 "849b8c69fdd886bda077eb76b01de27701e06dff6496695ce60a18fdd6a07ff0"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25371016fcb60f1829e848bd8447691a0b5380fb41c4550b1adfc824b401a27d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25371016fcb60f1829e848bd8447691a0b5380fb41c4550b1adfc824b401a27d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25371016fcb60f1829e848bd8447691a0b5380fb41c4550b1adfc824b401a27d"
    sha256 cellar: :any_skip_relocation, ventura:        "12c859451a1f9da2bc32334d9f221fe33a81e54f8d908cdf0eb44d5080361d32"
    sha256 cellar: :any_skip_relocation, monterey:       "12c859451a1f9da2bc32334d9f221fe33a81e54f8d908cdf0eb44d5080361d32"
    sha256 cellar: :any_skip_relocation, big_sur:        "12c859451a1f9da2bc32334d9f221fe33a81e54f8d908cdf0eb44d5080361d32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0801d0a66a3d99a0231e46e3e0087c5de3758c904d75c5dbc13313cbf2b76279"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https://ghproxy.com/https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./csvtk"

    # We do this because the command to generate completions doesn't print them
    # to stdout and only writes them to a file
    system bin/"csvtk", "genautocomplete", "--shell", "bash", "--file", "csvtk.bash"
    system bin/"csvtk", "genautocomplete", "--shell", "zsh", "--file", "_csvtk"
    system bin/"csvtk", "genautocomplete", "--shell", "fish", "--file", "csvtk.fish"
    bash_completion.install "csvtk.bash" => "csvtk"
    zsh_completion.install "_csvtk"
    fish_completion.install "csvtk.fish"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end