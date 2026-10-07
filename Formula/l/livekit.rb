class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.13.8.tar.gz"
  sha256 "fbc005177b8da6168ed01046e925c9fae29ea911c1feacae394eca90d661757f"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "e6e162e3da8b4364f6e8c8aab660e1f1541ab4682616da05febb4f98a9f6c048"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "d5bc34753c85c0c6b2be328d57d9c2f5020c527a95ba81baa56856b547f451fe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cf9bb56e9fc9e6d59c60f88a1cf4aab3a3ce19fba1f66140c80bd0b75531c3f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "d044cf399d3f3d2a65db8aad7cffda0000da066ec808d77733a0a7a102d0cf13"
    sha256 cellar: :any,                 x86_64_linux:      "59daf0ded35b966966fb2c274c25c8d8ad1cc2b3f1d588ccc729d4fa480fcbe2"
  end

  depends_on "go" => :build

  # `test do` block runs a local server
  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    spawn bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end