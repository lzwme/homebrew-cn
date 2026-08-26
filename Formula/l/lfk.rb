class Lfk < Formula
  desc "Terminal user interface for navigating and managing Kubernetes clusters"
  homepage "https://github.com/janosmiko/lfk"
  url "https://ghfast.top/https://github.com/janosmiko/lfk/archive/refs/tags/v0.18.2.tar.gz"
  sha256 "fb443b03158ae39ac0b7d14b98d4d839ba38114d7bdfdce199d0bd8522046e48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7e4c1a3a59e96c9780ee48ba85f2d34fc4f125eb1ffb3ebbf74efb49eb028216"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94c464029c4a2dee201fb8eca61be5d6df7fded92371e87c7a70ab897ac18aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e2499496c96bb6342aab07bbbae7576f29824f407d8e5ef4e0f9feaa55973188"
    sha256 cellar: :any_skip_relocation, sonoma:        "d4b78ca469dca6e09e25f1745a2ce596b7bc396cf015d74dffa10f0db8869ef4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26688a7b5aaf9ee0a221926cc6276e1019a7bc6e869fd8a936ccb73b8341adc9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1f1c994ecdfd22feb1b1560bd46a25330cb0ce3352948b6d473d8d565e4bea2"
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