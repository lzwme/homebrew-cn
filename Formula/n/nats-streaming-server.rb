class NatsStreamingServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghproxy.com/https://github.com/nats-io/nats-streaming-server/archive/refs/tags/v0.25.6.tar.gz"
  sha256 "6f53792784e909870c04441127ca855b6d4cf007ccb93d8884d3278fd23b74cf"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-streaming-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "206984a6cf01469dc3b1bb02c92bfea8d2b742be41d9b0f67f520efaeb743a18"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "faca0aecf3e91bc9647dcd85f617d6c8531641d79856895948601cb7151c5f7b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f1a114a043e845b36088cbe115f186966b3797b7a1298afa05c084ec81375e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "c2c2b7b5ab4b94551dde455c6ec5ac52dca72a5870245024a0b6c797f51a3e1d"
    sha256 cellar: :any_skip_relocation, ventura:        "d8e27e58088ba913c7847b85e0c518a4398010e73815e2eb07478160f1b88fa1"
    sha256 cellar: :any_skip_relocation, monterey:       "44ad763490fb8fb3d6676c0956ada1d4a8716b149a9fcfbc625b53b15226d26a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f24c7b57b3e4e5dfe672f92a7fe4386ec74a1c807666643bf895b47d57e450c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-streaming-server"
  end

  test do
    port = free_port
    http_port = free_port
    pid = fork do
      exec "#{bin}/nats-streaming-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    begin
      assert_match "uptime", shell_output("curl localhost:#{http_port}/varz")
      assert_predicate testpath/"log", :exist?
      assert_match version.to_s, File.read(testpath/"log")
    ensure
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end