class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.55.tar.gz"
  sha256 "0743ed504d482a608f3e1f3b0a448059565e4b950aa0c22d2a5ff6ced6e3f62e"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1e0231970599d83496d233bcc20e9725300e9ab3c23912e303b1ee154a3229a0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1e0231970599d83496d233bcc20e9725300e9ab3c23912e303b1ee154a3229a0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1e0231970599d83496d233bcc20e9725300e9ab3c23912e303b1ee154a3229a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a3449842363074e79c2b0ba76b17b3b81ec4f15d4bfae96a3c2e99740f6b4abf"
    sha256 cellar: :any,                 x86_64_linux:      "25f8c83f82ecef8c50e7ce05e0a40a65bcd090ca563dba1091a34dc75fb21d9f"
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