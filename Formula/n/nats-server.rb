class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.8.tar.gz"
  sha256 "f0a6c3a79cafdd1258cc1970ac5f9b2da603c44f3ea636cab93417b8fa0c0b1a"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "606ad19e8cfbf7ea1a3e709d74a52bf567ebbbb8351308d50774b261e84aa88d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ace6d448c5f68b8c69f571399a27774148ee5d6abb860a172ea718d9cc7c8c46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec12db1bc6dd0d3e2cefb64715b6721c4d28ef2864082e7e1d9cdc3ea1839ec2"
    sha256 cellar: :any_skip_relocation, sonoma:         "1a4fde612632e3fec15346690eb66f07e2279896b6ff21c398be2d058df29d04"
    sha256 cellar: :any_skip_relocation, ventura:        "d6188aa5a704e7bbf77737f29d2609020d506f638f6d374a68dfb7a953dc60ee"
    sha256 cellar: :any_skip_relocation, monterey:       "0a3e000ef1cbe93c89fdef6b51704ee99f277f634fbe4beb6a16abac6ebeacb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b3fe53eed4a7afc43f5a281715cddd80e065f6119c3991059118445069ed686"
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