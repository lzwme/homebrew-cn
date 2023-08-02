class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo.git",
      tag:      "v0.116.1",
      revision: "3e1ea030a5897addaf9d113d0826709fe07f77c0"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2148d6b2bf0581b14f91f9064b63dbdb95c027c25fe1ae1f1cf0566386f5a3aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11117039826030efd1d11c421c0ce055f8d08f30a22b95b2c382f218e4be699e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3281dcb49ce00052f6a19a3c08ba682d746786d72035bcbf6fb811dd7c411d21"
    sha256 cellar: :any_skip_relocation, ventura:        "c52a70a4bc3ca791905b0228b1d3b52d3c28fe08acb51e1b0cb74e18a11c4558"
    sha256 cellar: :any_skip_relocation, monterey:       "5a558796d1f956c3660c05f322991d68d353914df5f0a5be11c406f198843c6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "81ac73c95fe93fc443f10ae4ffc4486ffad06e2f7692b4aa4c9514760848e93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9c774e13bf0b73ec0f9a9c87c5e68345b0dbb0ebb5ce45a9e89ef70b3bc8af9"
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