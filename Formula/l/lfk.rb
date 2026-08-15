class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.17.1.tar.gz"
  sha256 "7217d2d3f02a573c0fdc1fe6af8deefe4e80e60627f9daf3ece5dc163d6bdb00"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b4e2a8cb4d20754c657e1eb00c7062fa8723298fb3fd00418a22fd0a1a128bea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6004183ba620df075cb2dfd65a0bc0b4d632e70888430ad3d4d19cff3ac05ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4c713d0ffa11578e44a573e217f9b0a8c8d58af098d62a60353304741279c01"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d7e83b77fdd5c628c57205839c8711d87df20b6eeee899fab0c6aa320f980ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164954bb7b605045621516c175ba2729ead0d9ac0fc0edfc17b3a82c74c50d85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c01d87210efbca41cf3dc36ca5a84ff0ae471aa9a1675bf1dd2046683fd11e91"
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