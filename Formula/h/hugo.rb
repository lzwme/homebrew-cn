class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.120.4",
      revision: "f11bca5fec2ebb3a02727fb2a5cfb08da96fd9df"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5dd5199ebfee2de5a900f81c01f0a944849d1627eb1cdfad7c4f57522243082f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5011a8049b5daff4c1e5192376c384bcca6bc2f5ecaedb35a50a4b5da6ac119e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d603c2c1aae64bbabaaf092377ae2e8955bfe9ed5cf3cb58bd80e63b5f9bbf2a"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a2628d8d83ea39f7313e5ba63d2eca11ea34af6c79e9189ad22bd2d2a2ad5b9"
    sha256 cellar: :any_skip_relocation, ventura:        "c93dc4be70e0c76f12cc48a0006df403b2d39ec93db3e6f70b56d25e9ad4e8d1"
    sha256 cellar: :any_skip_relocation, monterey:       "72e7f38ed5f12ad6f17d395e3ebf5f3afa0ac12ba292d41406fc1755b504a9ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b53f30bddfb35fbdec42c75a8de755d171f2353f2c8b47eb216c07f5f294b389"
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