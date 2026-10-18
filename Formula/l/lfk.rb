class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.7.tar.gz"
  sha256 "4a854f7b380696ada35b538d9207a529cfb23e5b1fc87d0282979fc7fbbb745e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb4a74c717a9e8d4a25347109cdfac1a17d4f02ee497effe19abdb59295a21b5"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cb4a74c717a9e8d4a25347109cdfac1a17d4f02ee497effe19abdb59295a21b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb4a74c717a9e8d4a25347109cdfac1a17d4f02ee497effe19abdb59295a21b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3490f281072aa4cb7185b31232b61bcab7644fe1e33cb93889dfee8881a2066c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "dbb6541d83f7e0e9f7687971504b78d035b8f9987848bc8dfdad75f872cfe0e6"
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