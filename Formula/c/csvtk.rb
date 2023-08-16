class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSV/TSV toolkit in Golang"
  homepage "https://bioinf.shenwei.me/csvtk"
  url "https://ghproxy.com/https://github.com/shenwei356/csvtk/archive/refs/tags/v0.27.0.tar.gz"
  sha256 "9679315c8937f37a3d4ff7230df2502feb64fa6a8b937a89ae49b276411f3f9e"
  license "MIT"
  head "https://github.com/shenwei356/csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbabb1afb6103c460595c43e711870aa4a983ab283159e15e70145fac462fb88"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c124f09bb32b0f56f7d97b52c0f80ccd6f5aba9fc3eb842c30067161ee5701c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcae83fb16e81c50e68c38c22f65ae758d27b566d6b1a82c19764d1403805ce6"
    sha256 cellar: :any_skip_relocation, ventura:        "2d220a3049ca384bc018b7b079987dd1ab59f2750892aaf0a149c0d034b55abc"
    sha256 cellar: :any_skip_relocation, monterey:       "6c94fefa1a00e30aac147f3aa0c5e89a1a02c2d2be5871cfd1158727b8621ad8"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b72fc178c40dd9d9756732652e876f0c9544cfe0c5c2f31dfdb703a7adc5b54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92e22a033958ca0d1b36903af61d4e18961ebbec39ea7f7000b3bae157f8b0c7"
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