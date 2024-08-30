class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.20.tar.gz"
  sha256 "598704e96ea92fd74283526c9b6044df8b54e4cdccf9ddc5e25a52249c44424a"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "b20ac44cbc64a7159359e57b093e44d0c163739d31f29f11b21b5addd4fdedf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b20ac44cbc64a7159359e57b093e44d0c163739d31f29f11b21b5addd4fdedf6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b20ac44cbc64a7159359e57b093e44d0c163739d31f29f11b21b5addd4fdedf6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b0397cf4734dc4f8ffcc31c2b8910d92d488f677b2dc74c58781eb3850fcc426"
    sha256 cellar: :any_skip_relocation, ventura:        "b0397cf4734dc4f8ffcc31c2b8910d92d488f677b2dc74c58781eb3850fcc426"
    sha256 cellar: :any_skip_relocation, monterey:       "b0397cf4734dc4f8ffcc31c2b8910d92d488f677b2dc74c58781eb3850fcc426"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76b94a909d99c303728172a6f16d80c90d3fc0889d4461fcbb3b39576b8ff433"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run opt_bin"nats-server"
  end

  test do
    port = free_port
    http_port = free_port
    fork do
      exec bin"nats-server",
           "--port=#{port}",
           "--http_port=#{http_port}",
           "--pid=#{testpath}pid",
           "--log=#{testpath}log"
    end
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}varz")
    assert_predicate testpath"log", :exist?
  end
end