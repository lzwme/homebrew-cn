class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.132.0.tar.gz"
  sha256 "81bb859d077f3d4927c3a4bee196a7224164681a36a6b0ea111381e8f31c37ec"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d367469781979a67bef2bd2c98e2ecb52b4c5efbfbcabef6c6366844661b7160"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f37b5fec29efefd510a5d85de61c9400e9d6f1e0cf92d3dbac977d76a4be2ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02f558aa2f4d4c3b9f72cdb206416e1431357693dc34718b5fb679ecca89ee63"
    sha256 cellar: :any_skip_relocation, sonoma:         "b946272a1d31046cb62b9378d26927a9270d93994d9a2fbbf4a45e7f5cb4e78b"
    sha256 cellar: :any_skip_relocation, ventura:        "72eb21e517c2a9b79e4d7bb63da1359d768fe5d12060aefa422a36e8146cb02e"
    sha256 cellar: :any_skip_relocation, monterey:       "1da633d28defdf05499a95977c6ab812105fc0a761cd84bba92d0e01a9ce179e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c5b1e14e1b9fff5ebabc2bc14ab899e65cd0a3aaa284cce33bdde8fa675b66d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{tap.user}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags:), "-tags", "extended"

    generate_completions_from_executable(bin"hugo", "completion")
    system bin"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath"hops-yeast-malt-water"
    system bin"hugo", "new", "site", site
    assert_predicate site"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin"hugo version")
  end
end