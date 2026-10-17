class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.6.tar.gz"
  sha256 "900823213548673c30b6121469e38dd6078658d800ab4a9e9d4b5a1ea1e166fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e0aa16a2024212656b11ec968108ce11f1060f7bda51dd26851e9f1bf1c97a86"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e0aa16a2024212656b11ec968108ce11f1060f7bda51dd26851e9f1bf1c97a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0aa16a2024212656b11ec968108ce11f1060f7bda51dd26851e9f1bf1c97a86"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "970cfb8b86ff01f272ab23cee38f9290fd613090dac4722c8d4767e8ad2fe949"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1469333e9bdfb4e80db0e56fa487ca2ae3f8b836b24a2280dbcc2494a494102c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end