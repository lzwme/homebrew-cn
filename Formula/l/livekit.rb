class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghfast.top/https://github.com/livekit/livekit/archive/refs/tags/v1.9.9.tar.gz"
  sha256 "f9aae7627cad57426eadf5d9550eeddfad22720d8e68174c3d9ca2c51192ed02"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "87f2e2ac646dae786e4cd7b69e60be21ea3bc06fbb51a1ad4fe42dbdd2daa941"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70f1c4892321a2c0592f32d866fb5c0d1d57c80ed176fd5147306025f5b17a02"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1a1bc1c14b720c9cbb39cec9a7505385bda0d24166e6da4f5e081f1607317f0f"
    sha256 cellar: :any_skip_relocation, sonoma:        "b2ce63bad8d57dee61348d23e61386ecadc7c307bf07150c76aa84a234fbcae5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cf300ec794f6a338671389508bb131534c57ca58a3022005ec2cc4b85afb7607"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39197b8a041dbc256209de9e06d9b7e6c2e039405f63298221818386d56104b7"
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