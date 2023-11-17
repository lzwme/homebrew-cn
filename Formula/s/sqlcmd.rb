class Sqlcmd < Formula
  desc "Microsoft SQL Server command-line interface"
  homepage "https://github.com/microsoft/go-sqlcmd"
  url "https://ghproxy.com/https://github.com/microsoft/go-sqlcmd/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "e6ab8eacb98836f5f101792713692bcfce1ce864f9ae471545847d6b92948328"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8a2073142d63dd5006617a87f7ad1295510d06487a2f9049bd59f695a755a9f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3b2071f39c57875bc2c6e88110ddfb205a98d1ede9d11c73de6c9f6f8064a046"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e630d2ab204978c894a3543ef39e1f2c213f4f806e1ee65aeaa6cf848531ea58"
    sha256 cellar: :any_skip_relocation, sonoma:         "a367e1e2af87cfc231e35a95265465a94a6c581182d526733bde3b012cf3c944"
    sha256 cellar: :any_skip_relocation, ventura:        "ce9399a277de1c39eb4f617f63e5f5b6fa3ac57f78f8765fbee5ad726bcd4b92"
    sha256 cellar: :any_skip_relocation, monterey:       "1a0318610bf5911ee0183f137b89ae856745d399194b183fe8eb03b30d6361d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6af41f9617bfe7084bb1b4600528f3ce9d2fa0a2e25225200fc1f7d9d49e174a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/modern"

    generate_completions_from_executable(bin/"sqlcmd", "completion")
  end

  test do
    out = shell_output("#{bin}/sqlcmd -S 127.0.0.1 -E -Q 'SELECT @@version'", 1)
    assert_match "connection refused", out

    assert_match version.to_s, shell_output("#{bin}/sqlcmd --version")
  end
end