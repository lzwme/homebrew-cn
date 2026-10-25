class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.23.0.tar.gz"
  sha256 "c6bca2748c6d5752a24837fc0080767559308fa28496b49dc03135f36b536d4b"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e7003011694ae7977dca04f7d1e443464a14442f5804cb39fa2078aac0c1792e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e7003011694ae7977dca04f7d1e443464a14442f5804cb39fa2078aac0c1792e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e7003011694ae7977dca04f7d1e443464a14442f5804cb39fa2078aac0c1792e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "95ece7f4a10f08fc3733bfbfa71493c377a92e8cdef9cc78dc5241aa0ff1790e"
    sha256 cellar: :any,                 x86_64_linux:      "e98e5f2f1578a2637378dcc0fa3f9994b97e2fac4286e36e354cd4c5499ffff7"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/mark"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mark --version")

    (testpath/"test.md").write <<~MARKDOWN
      # Hello Homebrew
    MARKDOWN

    touch testpath/"mark.toml"
    output = shell_output("#{bin}/mark --config mark.toml publish 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end