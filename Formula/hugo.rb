class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.114.0.tar.gz"
  sha256 "485a0f8346ef74a89ab075613590bd94c86d322208cb7b567ceada758459e3b3"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d855a4d1a2f96aea568b8694a78cf37792d27dfeda5952eb14f7db24bb17e68"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1faeefe4cc60b83a40b12a42d13bd0acbfe87ca0054ca46b40ab999aec3b836f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "025db96eeca22a4c77d50e788626190e670e35038e0f23d8df1bdf3a42f91b41"
    sha256 cellar: :any_skip_relocation, ventura:        "2be3803d27e69ce29604dddbeb1abf1a27f5def9f1431d9029ed923f57f7b21e"
    sha256 cellar: :any_skip_relocation, monterey:       "685206e362fff4738ad73a3cf9426e1e42e9063d2494299b3aa1924ecbacca64"
    sha256 cellar: :any_skip_relocation, big_sur:        "a334b1b716cee126cefb82ebfd5cce4142a81992fe4dfc1832e2a3cd8dd80826"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5c9a84ab7140e061a87da5e6c696ca76ac274af5f203be961416cf240302099"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system bin/"hugo", "new", "site", site
    assert_predicate site/"hugo.toml", :exist?

    assert_match version.to_s, shell_output(bin/"hugo version")
  end
end