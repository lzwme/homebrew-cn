class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://ghfast.top/https://github.com/shenwei356/csvtk/archive/refs/tags/v0.35.0.tar.gz"
  sha256 "2b6c5a74a612f83bf95256fb4d926b929e9014a58a6d2969b00f078e33b8f1c9"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0ba1d0a8b8cc3fdbeb287117d25f6bdc0af13885f4a5b86720a74182410bee8a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ba1d0a8b8cc3fdbeb287117d25f6bdc0af13885f4a5b86720a74182410bee8a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0ba1d0a8b8cc3fdbeb287117d25f6bdc0af13885f4a5b86720a74182410bee8a"
    sha256 cellar: :any_skip_relocation, sonoma:        "85b122875a0c82ed4864a5a27276508bbf36dcff24487e124970749018fdd19e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c577606d627853521966817c24d4bdc5a24519288fde79de5079bc8f72c9bd8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50207f4035d14dc12d0b0ca5f7acc39900d43c24a9b5c2cd31964c6b157c42e7"
  end

  depends_on "go" => :build

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
    resource "homebrew-testdata" do
      url "https://ghfast.top/https://raw.githubusercontent.com/shenwei356/csvtk/e7b72224a70b7d40a8a80482be6405cb7121fb12/testdata/1.csv"
      sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
    end

    resource("homebrew-testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}/csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end