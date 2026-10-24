class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.45.tar.gz"
  sha256 "52755559656004d88962246ec2aa5a15f8ca59eef13daa5dafa92a42491d9cb0"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e4c4a693aaca60853aaff97e5cbc83a097ffd053b4df4427278a7e68ae8fbf96"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4c4a693aaca60853aaff97e5cbc83a097ffd053b4df4427278a7e68ae8fbf96"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e4c4a693aaca60853aaff97e5cbc83a097ffd053b4df4427278a7e68ae8fbf96"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b2336e7feea43c0c56807a16d5ebde0f9be11c474962ce53dce9d8ed84871c75"
    sha256 cellar: :any,                 x86_64_linux:      "45a628c7d669cd424091bbb613452247d91dc08826f4b21c74fc7b2e44c46f6f"
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