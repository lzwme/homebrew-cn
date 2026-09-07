class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.3.66.tar.gz"
  sha256 "2132305b4d908cb8c046488bfa22b7354e8553a3fcfa74a596d920bc11ef7303"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "77fe6d38bb2cfb631bcefc41a38edcdfbe022bdc0aae642979a8b55cf284a636"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "77fe6d38bb2cfb631bcefc41a38edcdfbe022bdc0aae642979a8b55cf284a636"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77fe6d38bb2cfb631bcefc41a38edcdfbe022bdc0aae642979a8b55cf284a636"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19a929be93cfa6f45d770de35c5a8ab4180f26c5671ac707e0d2b4a9784e2fc9"
    sha256 cellar: :any,                 x86_64_linux:  "c9a707088b8040d004e42acc8565a7853864c1664a89b0457fdf8e1f8c9c65d2"
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