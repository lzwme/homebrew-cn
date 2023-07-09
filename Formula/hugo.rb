class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://ghproxy.com/https://github.com/gohugoio/hugo/archive/v0.115.2.tar.gz"
  sha256 "69a5db803006d7abbd42f840a3bf4e85dc8e6722d5085043f863cebf605e7212"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08f53ddb57a5f668b1d7550aba2e7a96e03e47a25e37467d6283ec5a0e275cc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68461f0c03e920ea2de5e62c1007756c8ac197c6f957070d2ac4af2e6de53317"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec1c0fd6d4ca26296d4c0f8bddce5d0218b5a5d99dd1b9f18e331cc53d4623b9"
    sha256 cellar: :any_skip_relocation, ventura:        "350419767b8baade867ae5a76a057edbd1b3d277241e33053f150879aeffe568"
    sha256 cellar: :any_skip_relocation, monterey:       "139b88e7d5079b548807e32f1ca205cc17eb5f08a18bca06a6acdcba4bacf20e"
    sha256 cellar: :any_skip_relocation, big_sur:        "10468a8addeb2ca398efe8fb1073b7facbd5e48fc758c33fb79264312b2e960f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6b40f274dcb3cc5265ab717a5d246b1e026f0a8d99728a9a40a11853a59dd91"
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