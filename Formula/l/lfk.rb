class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.16.1.tar.gz"
  sha256 "e174f8a7dc31cf9b02ad6f021a78b548434a288e215d8e8f965f1c9cfbd8a7d9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c277b3df42db86a8346d963bda50b1ca47134a55e2fc7be76d6f3653ca9aecb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "931c6c5c531f9208e96d326aa6af275b01dc73c7bad09897325e688493af85cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "931c6c5c531f9208e96d326aa6af275b01dc73c7bad09897325e688493af85cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c26f86120cc60535cd9ea4f2b6d1f57c293c02ed4ee64ef34d35fb81a43e2ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f4c757a70d5ebb1cc36bf909998eadb8536dde4f7d41ea76c291ac639ad92d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "82860cacc1a5aade453f73bad9b8374620c711f749752593ffa946919dfc51e6"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -X github.com/janosmiko/lfk/internal/version.Version=#{version}
      -X github.com/janosmiko/lfk/internal/version.BuildDate=#{Time.now.utc.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    # This program is TUI-only
    assert_match version.to_s, shell_output("#{bin}/lfk version")
  end
end