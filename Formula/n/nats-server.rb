class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https:nats.io"
  url "https:github.comnats-ionats-serverarchiverefstagsv2.10.9.tar.gz"
  sha256 "29b8f9efa10682514a9dfb4e77357ff44cf25d0c4c24fa222e31d5b7440c3cf7"
  license "Apache-2.0"
  head "https:github.comnats-ionats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "024e261a548168e657b2152a12b9da90695db57e5fec076026e7e3f0e01e15e3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "063b833c20762fb5b592bbed2d9854a5425dc5231ddcf5d91c41affcc766473d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "586323d4f1fbbf75540053210206653ea3b0182c79d982cc1dda7c14544445fe"
    sha256 cellar: :any_skip_relocation, sonoma:         "be7e5939343a757a458d15a8c8e73f5a62f47e584eb45c226e206f1dde784662"
    sha256 cellar: :any_skip_relocation, ventura:        "5426fcb3400965ae496625efe71bb6cbd3542b402980cc274a407f9fcc244a7b"
    sha256 cellar: :any_skip_relocation, monterey:       "797e38f36a25abaf7de886ecd5d7d7fc7cdd3548d81c94523cb098e9110830ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aef9bbb30a0377579c8e35cf1207643d2a04165fa0066b1f868c43d735d65371"
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