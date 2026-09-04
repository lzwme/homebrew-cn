class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.58.tar.gz"
  sha256 "c8d528a94966f6c3f586fa514c699a1cca510d274f61c218bf28924d25b0ef49"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "df6e5e48ba10171c929a2d975720f2300ef11e2110bea72d639d9b604bbe8270"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "df6e5e48ba10171c929a2d975720f2300ef11e2110bea72d639d9b604bbe8270"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df6e5e48ba10171c929a2d975720f2300ef11e2110bea72d639d9b604bbe8270"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f976930eb493017fd9182efdac671ec3311a64de772df0a86b4c9072281fcee0"
    sha256 cellar: :any,                 x86_64_linux:  "53595da48073f782214be90b3838d86da25ad4731d9bc40659b3af7317528904"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.version=#{version}"), "./cmd/zot"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/zot --version")
    assert_match "zot: no credential for anthropic", shell_output("#{bin}/zot rpc 2>&1", 1)
  end
end