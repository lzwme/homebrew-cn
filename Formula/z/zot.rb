class Zot < Formula
  desc "Lightweight coding agent harness written in Go"
  homepage "https://www.zot.sh/"
  url "https://ghfast.top/https://github.com/patriceckhart/zot/archive/refs/tags/v0.4.49.tar.gz"
  sha256 "6f0fdbaf30e46b82c3c8e018561daf474430fa3d7b1e4315f4db2ad82bd712aa"
  license "MIT"
  head "https://github.com/patriceckhart/zot.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ed21dc9366e43f7e9fdc7d8d735ce6e06c418b72f7490060e17aa9c733fb2622"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ed21dc9366e43f7e9fdc7d8d735ce6e06c418b72f7490060e17aa9c733fb2622"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ed21dc9366e43f7e9fdc7d8d735ce6e06c418b72f7490060e17aa9c733fb2622"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f917d90593056cc0ed66cb7a719b2a634e86374445b2b5296572eeb2ddbe6d85"
    sha256 cellar: :any,                 x86_64_linux:      "96f67a36d417df9ddd5b6fa3b95809f57d9f5e13d98549a851d9e90b93f9812d"
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