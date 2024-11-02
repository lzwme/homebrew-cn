class Csvtk < Formula
  desc "Cross-platform, efficient and practical CSVTSV toolkit in Golang"
  homepage "https:bioinf.shenwei.mecsvtk"
  url "https:github.comshenwei356csvtkarchiverefstagsv0.31.0.tar.gz"
  sha256 "ac28ae180d58b0214521a2ba5881ac3daf676ee2c39157366fad6cb56a64ba86"
  license "MIT"
  head "https:github.comshenwei356csvtk.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b3bff7148c3fca85c1a5fa275eaf58df1e5353a2683b60102c23ee1e3a359b0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b3bff7148c3fca85c1a5fa275eaf58df1e5353a2683b60102c23ee1e3a359b0e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3bff7148c3fca85c1a5fa275eaf58df1e5353a2683b60102c23ee1e3a359b0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "92edbcfbbb3e7d2b71353cdda8343a542f190b903bbb67e5bb4cbcd627a58c91"
    sha256 cellar: :any_skip_relocation, ventura:       "92edbcfbbb3e7d2b71353cdda8343a542f190b903bbb67e5bb4cbcd627a58c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25952e330b40f92c0a651badca0f76e6496ec3cf979b920e3a15a6fe192c1c2d"
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