class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://ghproxy.com/https://github.com/hashicorp/consul/archive/refs/tags/v1.15.4.tar.gz"
  sha256 "b922ff834b41e119d293e856a8c2cd745842476a90baa6c9f0681bfa32b46133"
  license "MPL-2.0"
  head "https://github.com/hashicorp/consul.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0efd3d4408496753956a48d6527427238c3580e1573ea385475f64241a27e582"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5d59fee5a7515294116eb18089e2ea989be5dd5d35e397e072a5bed051434369"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4fa389ef7a6daf142159c4dc8e34be6a73c5d2727071b3e41df5b44b7dc2d41"
    sha256 cellar: :any_skip_relocation, ventura:        "bb3add990d2a4b07b7eaba2094865813a493c97f66022ab9a65e4df705c81bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "ebf6147327a95e2fe9af0e216848b3b256ea5ba74a3f70457a2fe856a8442e21"
    sha256 cellar: :any_skip_relocation, big_sur:        "db68faa3bc71723fb5ad81c4372672caf37e1a6abc824f8f72745942b0f3aca4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74b5101d4100101a3b7a0cc9bd8e42a122ed34fdf56099c15b9383bd827436c5"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  service do
    run [opt_bin/"consul", "agent", "-dev", "-bind", "127.0.0.1"]
    keep_alive true
    error_log_path var/"log/consul.log"
    log_path var/"log/consul.log"
    working_dir var
  end

  test do
    http_port = free_port
    fork do
      # most ports must be free, but are irrelevant to this test
      system(
        bin/"consul",
        "agent",
        "-dev",
        "-bind", "127.0.0.1",
        "-dns-port", "-1",
        "-grpc-port", "-1",
        "-http-port", http_port,
        "-serf-lan-port", free_port,
        "-serf-wan-port", free_port,
        "-server-port", free_port
      )
    end

    # wait for startup
    sleep 3

    k = "brew-formula-test"
    v = "value"
    system bin/"consul", "kv", "put", "-http-addr", "127.0.0.1:#{http_port}", k, v
    assert_equal v, shell_output(bin/"consul kv get -http-addr 127.0.0.1:#{http_port} #{k}").chomp

    system bin/"consul", "leave", "-http-addr", "127.0.0.1:#{http_port}"
  end
end