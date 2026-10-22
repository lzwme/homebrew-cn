class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.12.tar.gz"
  sha256 "b671a5b374bbe01533931b4f4d6f4f5f50c53d6fc15f4c7a9e0d8b174b9983a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "d7b969f789aa63a345b6b5a1186c0fc86310fd27a55aeeba443d691dc8e4cb93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d7b969f789aa63a345b6b5a1186c0fc86310fd27a55aeeba443d691dc8e4cb93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "d7b969f789aa63a345b6b5a1186c0fc86310fd27a55aeeba443d691dc8e4cb93"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9ad93389dc10187645d63dd5e963201cc1aacee5cc78bcf32a33f7fb1e97cca5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "ff232c3d4f5cb752fabbf40b7724a34475e16eab12283abf809951d0b85821f5"
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