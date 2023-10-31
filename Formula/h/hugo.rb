class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.120.1",
      revision: "16fb2cae88eb6add7d12e9fbfcf01d8670e60a35"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a02f12a9862875fce89bdd7ae1694ae838e5b0df952930016527e7f2dc19f308"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f80c28b3011a209d7c7713e98cf0d315511ad26bd7d1a49e1b7eb4aaba01a2a3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0a8a29d2ba8c8148d9f010cfa67b92fa473ee43d7b4d1b5c42e1b793ecced96"
    sha256 cellar: :any_skip_relocation, sonoma:         "b7beb929ad58612db9c44c3de77d17a06538a830d2d07b16c869faef29a83c63"
    sha256 cellar: :any_skip_relocation, ventura:        "79d3a289cd2b30cedb057fc2f900097032194e19f2bd66cafc06c0587870ea52"
    sha256 cellar: :any_skip_relocation, monterey:       "94a9d202d909f42e6eb27525051938988d8f915d937c1114ae85bd0743113e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bf79395ab6490c2e756ccbcbb30e3bada8f655e619d7c435f5655e62745e0cc"
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