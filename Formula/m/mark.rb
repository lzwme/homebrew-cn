class Mark < Formula
  desc "Sync your markdown files with Confluence pages"
  homepage "https://samizdat.dev"
  url "https://ghfast.top/https://github.com/kovetskiy/mark/archive/refs/tags/v16.18.1.tar.gz"
  sha256 "d19e26698ce4ae73808785f5dd50456632595fe2980697b8fcf3c2826a358ad2"
  license "Apache-2.0"
  head "https://github.com/kovetskiy/mark.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "555d471996d65690148cb893af33c7e11ed8c018d7c9cb9fdb1d147e221e5dca"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "555d471996d65690148cb893af33c7e11ed8c018d7c9cb9fdb1d147e221e5dca"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "555d471996d65690148cb893af33c7e11ed8c018d7c9cb9fdb1d147e221e5dca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f446729754dff90c96250ee8936e59bee27a3e20438760c0816ab3880095f884"
    sha256 cellar: :any,                 x86_64_linux:  "dde1ee0c7786458ba4fda093ba610cac68f5a27a12603a157c3e384baaaf1fcd"
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