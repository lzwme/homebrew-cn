class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.20.4.tar.gz"
  sha256 "d7f97042a5348cc21a21ca689ea61fb6ac008f4dcab21fd4bbcfef03c0ad2ff1"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "eacdfcc4c04b596901c72f7b5d4b240f82e2525435130b596a9c0c8dd0a0772c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "eacdfcc4c04b596901c72f7b5d4b240f82e2525435130b596a9c0c8dd0a0772c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "eacdfcc4c04b596901c72f7b5d4b240f82e2525435130b596a9c0c8dd0a0772c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "5b3310688a120a0693dd1d0b01ab3150692a571177e48821f89da9350326993a"
    sha256 cellar: :any,                 x86_64_linux:      "cbe3636201f24ca4376358de3612e3a5a28f11830b581855cb12831152f4ca89"
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