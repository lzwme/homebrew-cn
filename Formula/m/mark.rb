class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.21.0.tar.gz"
  sha256 "4048790437adf041fb9359a23a467aff6edcfa725f3aaed3a9674f47edb19b11"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e5002b352e99698609afcee3b8d4722be4ab27a7b295c2706a8cdc901247c0dc"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e5002b352e99698609afcee3b8d4722be4ab27a7b295c2706a8cdc901247c0dc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e5002b352e99698609afcee3b8d4722be4ab27a7b295c2706a8cdc901247c0dc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "579d3ec7376a16755c09eca9aa8d0ee655bf91d3a8fa932f109bc1434764aca2"
    sha256 cellar: :any,                 x86_64_linux:      "07320b99fa736d7d0fa29d42f1b57b15925767a76ee67c11f6bafa848cd7b7a1"
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
    output = shell_output("#{bin}/mark --config mark.toml sync 2>&1", 1)
    assert_match "confluence base URL should be specified", output
  end
end