class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.9.3.tar.gz"
  sha256 "161d814f145806f2bcaa85b3fea50f0fec5f96ec208aa0aef0c542c99ae42ff3"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b5819428a969c257b1a1518e4e069b70f147b389c4b5f51b5432e76d1e1d3c99"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "564617cf13c1bfd86636f55701d98692da7710be6b64a07e3416e35ff1d862de"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a70374c7a44210d29d732e5fe3d70c29a469350089883eb5c73499a536231115"
    sha256 cellar: :any_skip_relocation, sonoma:        "6dd1e660b3bc83a00f373dd88ea68765eba207eac790bdb980820b26eb34766f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1411c323d35de6c0d543fcb4b47c9160b790d9a6159cee55cc6b51268f06665a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ae93e879185831b41805fc281a764e6a122b6574e99bdab749fa2e31966bd821"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"livekit-server"), "./cmd/server"
  end

  test do
    http_port = free_port
    random_key = "R4AA2dwX3FrMbyY@My3X&Hsmz7W)LuQy"
    fork do
      exec bin/"livekit-server", "--keys", "test: #{random_key}", "--config-body", "port: #{http_port}"
    end
    sleep 3
    assert_match "OK", shell_output("curl -s http://localhost:#{http_port}")

    output = shell_output("#{bin}/livekit-server --version")
    assert_match "livekit-server version #{version}", output
  end
end