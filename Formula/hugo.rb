class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.115.4",
      revision: "dc9524521270f81d1c038ebbb200f0cfa3427cc5"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2289e5da8b58b0fe78bff2e7486de94e5606e8b0d55c377d2d4f1fb225b7ea37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee50462d97b2ad56ab807afeb93c7c360155c9defed71cce71fd81b108d9bc3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c019f6161ef85a352c07766c71549423be025b19cad9a23e03ed8e465d9f46dd"
    sha256 cellar: :any_skip_relocation, ventura:        "093ca92022e8b554f4097366cf09da49d6fe3a1f1e0ea77fa9972f6ce3b5acd6"
    sha256 cellar: :any_skip_relocation, monterey:       "3051c4c45d5c24adbfe0683e035b9a326613c148b298bc518650f5e43f54e1df"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb2f93f14040e0907f9a9ac70476d2b556df378e693aadd57c92a6bf6e90279b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aac7616de0e9da143d88267e2f9ed21b7046b47497fe3bead1ac382036e95fa"
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