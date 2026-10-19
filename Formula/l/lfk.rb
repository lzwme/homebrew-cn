class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.8.tar.gz"
  sha256 "a027d55f7efb4c98373c872465e2e06e112a6e0e008e8d3b6e43ec82b1e39c4b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "aea3b03d75ac1c0ca973ade1923fd57843ab29d548faa4669115fd59f03c0ab7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "aea3b03d75ac1c0ca973ade1923fd57843ab29d548faa4669115fd59f03c0ab7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "aea3b03d75ac1c0ca973ade1923fd57843ab29d548faa4669115fd59f03c0ab7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "7dec073f79f79a0951bfa0b8cd826b63a201ad758277e8b2c6eebc9812659e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "0b6f6f6ac877516767696111a7266e28306a844522ad0289c681cc170684d7b5"
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