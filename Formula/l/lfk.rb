class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.19.5.tar.gz"
  sha256 "f142146acad1e840ed93cde738aaa054b7ec4f43e1b0ff6a8ab01fb43757cdf1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "47c8954836f884c3bb53b94c0f86185dc62a32765fb0f376ce96c236b9bbdf93"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "47c8954836f884c3bb53b94c0f86185dc62a32765fb0f376ce96c236b9bbdf93"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "47c8954836f884c3bb53b94c0f86185dc62a32765fb0f376ce96c236b9bbdf93"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a17e656c0cd86fefd7ab35a8f31069c577bdc3e40b60ef169fe857fb07b42650"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "1939787722cf9b94553d8469affb841e8883ded876af8b6edd59199594be13b7"
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