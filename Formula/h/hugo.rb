class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugo.git",
      tag:      "v0.123.6",
      revision: "92684f9a26838a46d1a81e3c250fef5207bcb735"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a918aa8d04205ddfec2334af29fccd30776a7b107bec97a8a6474024968e9f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92794332004d2c1d33fbc277693230578fac3da81791616c3b74acb0b004813d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7bbd8d46cf50fc806b498667bc4aaa6085f26c61b982707b84185d2966afb846"
    sha256 cellar: :any_skip_relocation, sonoma:         "f9ac5dc938477817edcb43c8db391eb63d8138a7f8d75b236f9c287f34c271db"
    sha256 cellar: :any_skip_relocation, ventura:        "4453713ec4fff8e97c86aef7e3519ad91ab129f3f3c3491c8ec9f601d05104d9"
    sha256 cellar: :any_skip_relocation, monterey:       "b93a942d1d3544df7478cc3e5f294697f22e583463ef534e2deaf3ef9c7099b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f243f5e9879d4f5759d350c9d065bb014daacc3856b1dea8007d60083487018c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comgohugoiohugocommonhugo.commitHash=#{Utils.git_head}
      -X github.comgohugoiohugocommonhugo.buildDate=#{time.iso8601}
      -X github.comgohugoiohugocommonhugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

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