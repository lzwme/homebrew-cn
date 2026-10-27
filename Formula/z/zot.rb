class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.51.tar.gz"
  sha256 "13be5745c6d35f012b9564ae547cd46238d7f60f1ff94d2bb0bdfb100aabc2e9"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a4dffb4cd43b69ce795b225e0cfc46571583ce30f2169f58e4ebbb2a94698594"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a4dffb4cd43b69ce795b225e0cfc46571583ce30f2169f58e4ebbb2a94698594"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a4dffb4cd43b69ce795b225e0cfc46571583ce30f2169f58e4ebbb2a94698594"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d8ade03d0f18f22ca929da214aa1bfcef0c7c0a5490215dfedc157d0c17f1193"
    sha256 cellar: :any,                 x86_64_linux:      "4427d7fd9040db5e73abd37a5dfd45d41dc8e0f3e236d2b4b69a7ff2ee2c9ee4"
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