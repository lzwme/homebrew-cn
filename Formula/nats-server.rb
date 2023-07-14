class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghproxy.com/https://github.com/nats-io/nats-server/archive/v2.9.20.tar.gz"
  sha256 "e0d04f668f6f9afc652ee8f6e11dfba04058bcf32d9c62b6e42a1d515693af2e"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c1f41be8ab97fcabd04c024238b916d6207735c9b6252279f56cf9efe7c898c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c1f41be8ab97fcabd04c024238b916d6207735c9b6252279f56cf9efe7c898c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c1f41be8ab97fcabd04c024238b916d6207735c9b6252279f56cf9efe7c898c"
    sha256 cellar: :any_skip_relocation, ventura:        "ce338e53f0e6058f0d403cd20afb8d37bfe2427eaa188589d4644b698f09fb68"
    sha256 cellar: :any_skip_relocation, monterey:       "ce338e53f0e6058f0d403cd20afb8d37bfe2427eaa188589d4644b698f09fb68"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce338e53f0e6058f0d403cd20afb8d37bfe2427eaa188589d4644b698f09fb68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0186d56a151339477be9231974aabbb3eca91721940fb90a011aa73dedb4b47e"
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