class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://docs.errata.ai/"
  url "https://ghproxy.com/https://github.com/errata-ai/vale/archive/v2.26.0.tar.gz"
  sha256 "a54e5cce0b29e395a22a2476e42c52b2f2a9105caa9520ddf7b7cbf58fb3087b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d48068d29fc1f08f277107e1abcd4940b9cd3245913c9b2e1cc2bdd5579bdbf1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d48068d29fc1f08f277107e1abcd4940b9cd3245913c9b2e1cc2bdd5579bdbf1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d48068d29fc1f08f277107e1abcd4940b9cd3245913c9b2e1cc2bdd5579bdbf1"
    sha256 cellar: :any_skip_relocation, ventura:        "10f6604dc2c73d30a6fcd71bf93dea2d4375977c7aba759e24302f6b96e42dad"
    sha256 cellar: :any_skip_relocation, monterey:       "10f6604dc2c73d30a6fcd71bf93dea2d4375977c7aba759e24302f6b96e42dad"
    sha256 cellar: :any_skip_relocation, big_sur:        "10f6604dc2c73d30a6fcd71bf93dea2d4375977c7aba759e24302f6b96e42dad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "87ffb3bbcfbe0552643441d54f9fd946b0ab541285d0cc0ab9168876226528ca"
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end