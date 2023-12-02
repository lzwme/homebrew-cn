class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghproxy.com/https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.6.tar.gz"
  sha256 "05d803947d16a733c7057665b6b4dd656e1d2466b8d2158159e5d02eaf020373"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "07003eeefedd45be9f06536a3918196c85b8abd4129f6a26ec54aaed762e88f5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6bae0a4edddb5d77a14961a61f2bd64d6a1169f1d137aacea6f892c0b2004e8f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c448d16509e2655552702f5d9ae30802b6ca1118b792b8d34252011506a0e95"
    sha256 cellar: :any_skip_relocation, sonoma:         "6b61a5ad3210a8f111a68af725b5ab888fa9c5852b1695b690b5a17c2d873c5e"
    sha256 cellar: :any_skip_relocation, ventura:        "58d1e30908c2bb98749f40027a8b031055256a4288af2cfe2584387820eb7497"
    sha256 cellar: :any_skip_relocation, monterey:       "eb3e026e380f17f42388402173aa97cd089a4a163ef4c579d70c228cbb03cfd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "644782cb0d91b953d3f5885534d1ebc6702e46da4517ce4fc4e734945e9eafdf"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin/"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin/"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}/pid",
           "--log=#{testpath}/log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_predicate testpath/"log", :exist?
  end
end