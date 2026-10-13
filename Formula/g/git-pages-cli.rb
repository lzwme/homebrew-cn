class GitPagesCli < Formula
  desc "Tool for publishing a site to a git-pages server"
  homepage "https://codeberg.org/git-pages/git-pages-cli"
  url "https://codeberg.org/git-pages/git-pages-cli/releases/download/v1.11.2/git-pages-cli-src.zip"
  sha256 "d00d935b69a4fbf4144767d63e13cf81ac2b3ce14e7825167a404e2169196407"
  license "0BSD"
  head "https://codeberg.org/git-pages/git-pages-cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "490935500d696a399d7ab7e4d8eb179bd30997ced262cd4ce0ff80cf058b123c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "490935500d696a399d7ab7e4d8eb179bd30997ced262cd4ce0ff80cf058b123c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "490935500d696a399d7ab7e4d8eb179bd30997ced262cd4ce0ff80cf058b123c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9fa686eb678ce60dff5eb8c2293c92c532f1dc93f220c299060a547170d59e21"
    sha256 cellar: :any,                 x86_64_linux:      "637cea880009764048c6b583d343693823269cd43e1d7761965a05afc27f1417"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.versionOverride=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/git-pages-cli --version")

    output = shell_output("#{bin}/git-pages-cli https://example.org --challenge 2>&1")
    assert_match "_git-pages-challenge.example.org", output
  end
end