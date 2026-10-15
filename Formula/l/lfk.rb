class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.4.tar.gz"
  sha256 "04d4e8684a7a66496a559047fb7dc64e097b497b84df9acdd0eefd5aee1ffef9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "330f7701e7e50db45c68b45934e4eba26c59477acad31087692037cf5319296e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "330f7701e7e50db45c68b45934e4eba26c59477acad31087692037cf5319296e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "330f7701e7e50db45c68b45934e4eba26c59477acad31087692037cf5319296e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8dc42fe56ab8347b0c210e7fd3df249c9dc92eb881c41f9da28ed04ab33efd0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "825d2aef57949c1cff63c06ff911599f586511b4594420444c89d7655814fb30"
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