class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSVTSV toolkit in Golang"
  homepage "https:bioinf.shenwei.mecsvtk"
  url "https:github.comshenwei356csvtkarchiverefstagsv0.31.1.tar.gz"
  sha256 "f992fdd80c9cf4589931da9fbe7344b9e508fe53de54a8b8646c8fe83135f723"
  license "MIT"
  head "https:github.comshenwei356csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9ea9170ffd5bf473a7103d5596f55d4189681f2d01c63f42af6ca0dfe2afda74"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9ea9170ffd5bf473a7103d5596f55d4189681f2d01c63f42af6ca0dfe2afda74"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9ea9170ffd5bf473a7103d5596f55d4189681f2d01c63f42af6ca0dfe2afda74"
    sha256 cellar: :any_skip_relocation, sonoma:        "938fcdf81d3690a33f9c0b0e62c727dca842cb8b164250ba819273f1104c6b1f"
    sha256 cellar: :any_skip_relocation, ventura:       "938fcdf81d3690a33f9c0b0e62c727dca842cb8b164250ba819273f1104c6b1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b15df0347dcdea4fc8bd36c858095feb93e6d9369a0f001cf5a3934557d95c7"
  end

  depends_on "go" => :build

  resource "homebrew-testdata" do
    url "https:raw.githubusercontent.comshenwei356csvtke7b72224a70b7d40a8a80482be6405cb7121fb12testdata1.csv"
    sha256 "3270b0b14178ef5a75be3f2e3fdcf93152e3949f9f8abb3382cb00755b62505b"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".csvtk"

    # We do this because the command to generate completions doesn't print them
    # to stdout and only writes them to a file
    system bin"csvtk", "genautocomplete", "--shell", "bash", "--file", "csvtk.bash"
    system bin"csvtk", "genautocomplete", "--shell", "zsh", "--file", "_csvtk"
    system bin"csvtk", "genautocomplete", "--shell", "fish", "--file", "csvtk.fish"
    bash_completion.install "csvtk.bash" => "csvtk"
    zsh_completion.install "_csvtk"
    fish_completion.install "csvtk.fish"
  end

  test do
    resource("homebrew-testdata").stage do
      assert_equal "3,bar,handsome\n",
      shell_output("#{bin}csvtk grep -H -N -n -f 2 -p handsome 1.csv")
    end
  end
end