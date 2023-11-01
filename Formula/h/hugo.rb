class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.120.2",
      revision: "9c2b2414d231ec1bdaf3e3a030bf148a45c7aa17"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a7ecebdf1f095dc99886bee3527f1e2dfa776f96a9dd98be950665e5902fd7e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7f96b910d17079b12e209ebed6140426d87a86cf19f5fac08c95aac8abc42963"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ce0a898d8963a835b9a5535d50a5eaefe8e1a6f3d7fec5b1d5a44f3ef8ef1c8"
    sha256 cellar: :any_skip_relocation, sonoma:         "195c39ba0824af1e6c69da1a8458c18a3b18e9ecd57b297cb05900304b501969"
    sha256 cellar: :any_skip_relocation, ventura:        "2ac2426fac0ea1ca86013d2094f674f756ed236cad12dae940b8202097442d64"
    sha256 cellar: :any_skip_relocation, monterey:       "1768ebc2653cd64f44d5427b0799519782126c618ea4d841bec3e6652dc64b97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4de8b706aa8c7f18ef4f5adb4854398c488565553892fcfe39146d407f8eee86"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/gohugoio/hugo/common/hugo.commitHash=#{Utils.git_head}
      -X github.com/gohugoio/hugo/common/hugo.buildDate=#{time.iso8601}
      -X github.com/gohugoio/hugo/common/hugo.vendorInfo=brew
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")
    system bin/"hugo", "gen", "man", "--dir", man1
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end