class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https:gohugo.io"
  url "https:github.comgohugoiohugoarchiverefstagsv0.126.3.tar.gz"
  sha256 "2a1d65b09884e3c57a8705db99487404856c947dd847cf7bb845e0e1825b33ec"
  license "Apache-2.0"
  head "https:github.comgohugoiohugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4aaa26159cb9ca248beb921acce2a522219dd4d9c5fc8426411e6cda99119f92"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d05cfc18340ed42c8399e9d798013bd8dc4d2abfd8f20a1ab6a6ebb588001201"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8591a52021c33c22b97750ac17df084b5cf69146496481dc67bd79e14bc64ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "4d4d0f37981e2cd7da6cdf054738b77aa4b87924658d34e2c6778c822a0a25cd"
    sha256 cellar: :any_skip_relocation, ventura:        "4086de892c2a9130663295e7b260ac0eeea3e63ae99a00edf85c919306f07c04"
    sha256 cellar: :any_skip_relocation, monterey:       "720c5da5f454be6c6c0de58a245c6b86d0c14225ec009132d56265222038214f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4c282756ac6b0c1d5eec286936a064b53d34c1f41d75195589e5a298aeb2fd7"
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