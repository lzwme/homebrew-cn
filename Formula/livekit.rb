class Livekit < Formula
  desc "Scalable, high-performance WebRTC server"
  homepage "https://livekit.io"
  url "https://ghproxy.com/https://github.com/livekit/livekit/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "10ed20438784a4ea3a056ff9cc09519fdf8cfa8ab9d8e075e617f28a65b6eba0"
  license "Apache-2.0"
  head "https://github.com/livekit/livekit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d98f034bf9a6a5c52190016cf5df461a4b973623970b200c1ccd79a0c48c4cce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df9892495966e81aa22dedb24b494ff699ac196c35e7165962171522b7ce25fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f88fa81932bd28e6ec4aa76fda7760b08f5cf0830a033ffbad76b946ded1c7b8"
    sha256 cellar: :any_skip_relocation, ventura:        "beae2340841927bdb9723c21a99344c2ae2f3af9f4993c95dc01c3c5af04d674"
    sha256 cellar: :any_skip_relocation, monterey:       "538d2723daf0318b7be5376edf4e54dff91dbd283d9508438273fc50777c3066"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c6db4255c187164c8806c816397d0904954d642e5578a2241a0c32cae1435ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c5e90f5065842b7401edaaeb7029df1e58ae2203b025af5bf3dcab51a1cea6a"
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

    output = shell_output("#{bin}/livekit-server --version", 1)
    assert_match "livekit-server version #{version}", output
  end
end