class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghproxy.com/https://github.com/livekit/livekit/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "9776bc99b71507fcfebc4749407d3c12f2ed1ed8f6df6c3d70e8bd65e39b4ec6"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "88b88bdd5457cc87cbac2a2697c97abaacfde3345164c451dad2dea483643f58"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb974f71446318cf1e14e43e43ed3b20749c41bda5f7abf96f2643458c86daa4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdac09e428da93e63961f65939bdcad7782ea995d54620b0464ffae47c16f4d4"
    sha256 cellar: :any_skip_relocation, sonoma:         "459c067d1139d80b66f295a324fd6516a1d35f6322180d9922d4736d73b8ae53"
    sha256 cellar: :any_skip_relocation, ventura:        "e1f82859c7084faed8a727e61529671d65a3c6e1de4ffee81a04f7b737e513f5"
    sha256 cellar: :any_skip_relocation, monterey:       "319f56e3c044c0d097a8705b31378a0d4f8bf099ec42fb215d2a3fe30aa59810"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4466baea6a4d35b1e66638219cd551f09cf0af7223a3a7767b749d96de608ce0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(output: bin/"livekit-server"), "./cmd/server"
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