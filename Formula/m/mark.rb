class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.20.3.tar.gz"
  sha256 "046efc5a94135a16d661541cc8650fe173fd63a15b03a6f2c83ec29f0b9e4f9e"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5e649293cfbca5ea980a98ce57b0c091696fa90851f263fdbf6bed6120e64541"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5e649293cfbca5ea980a98ce57b0c091696fa90851f263fdbf6bed6120e64541"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5e649293cfbca5ea980a98ce57b0c091696fa90851f263fdbf6bed6120e64541"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e4be45e138a81a2d679e0c8901418f00b4c9e74876b6a064dcae079e346a5b34"
    sha256 cellar: :any,                 x86_64_linux:      "e4b944565ad1d61238cfa294e1dc16aeefde07c1ff9ee8d05651151d3058da64"
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