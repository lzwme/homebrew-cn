class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.112.7.tar.gz"
  sha256 "d706e52c74f0fb00000caf4e95b98e9d62c3536a134d5e26b433b1fa1e2a74aa"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2b450263f813eedec4826488e4e81182eca9d1700cf95516392e480740426017"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8117d995d9883994858770ee25d16a41d92e10916d6fb57e1569dd32058831c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31322ac21fb84b697dcfbb95a8b731540d08772cb6426221661c1d48b9eda66f"
    sha256 cellar: :any_skip_relocation, ventura:        "56a94cb692e51b861a17c530af8cd4c051d4204b0165177599e5a079bb460da8"
    sha256 cellar: :any_skip_relocation, monterey:       "d16bacef9855ae502231cb7903bb57643cfc60fd6a175f2644c7f12a8aad5f00"
    sha256 cellar: :any_skip_relocation, big_sur:        "9fe1af6fa20058ac8d5ab13961e06792707ad65a699cb9797d09781e8abe0679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c65132ac8c1d4cad5ca64071ad3316ae4e678ac119d9f38fb946953fa9a1c018"
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