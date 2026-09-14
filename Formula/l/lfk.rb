class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.13.tar.gz"
  sha256 "29c7e67cfcec97b8ea46a524da60cb058dd25f6a5446e25c622580872e5df01b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9fe595b4b148fd456ff432f915df8babd72ec42cb2b7a209ef790bac83875727"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "141d54e8887a726340bcfb2e95beb84392ceb1df4f098ce2aa86add1dceb3af8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b89bbc8159bbb5868c783752547a147186e16d368491be260108937fa169be13"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "daf44ffd9ad2f0814899336ecf3711503f5bfe3dc4da1f4ea122bf04cdf196b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "a295a85ba44280604e7a82804b60ada1cf9ee1fda1347bdc8ad212388639b820"
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