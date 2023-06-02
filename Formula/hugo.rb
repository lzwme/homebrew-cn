class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.112.6.tar.gz"
  sha256 "018371c7a426ac0f4f1bef45fc64b6771cd10edd02a71605507968ba913b1451"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ca3bea990a5fe146f28f809d4562f3a0839919dc5c1a1cd80f49df592a77c12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1d4fa1b6d76dc86d5e7d41308211cf78cd8ce08459ee9f60e136d21f511a3ca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b37931da1baba714e6f8a1f682b1dd9928db8264315ef1c15535ebc4d93fc8b"
    sha256 cellar: :any_skip_relocation, ventura:        "e02c7f818d812869fdbb315fad46c6d0535ce3075766e1c799f10d1abaf5996a"
    sha256 cellar: :any_skip_relocation, monterey:       "0409baaf67e7737387ad349c27a1e518da523a45b8e3ebea34616ceb7e82e706"
    sha256 cellar: :any_skip_relocation, big_sur:        "407b2f92facd7a757bfc33cc522c8b1a95f2a2defb300295f491c1e018251a85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ab2d1f21d46356ae0f8b270dde121e956e1411f52f95b5bab9b3cff19f4ec4"
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