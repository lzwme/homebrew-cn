class Fabio < Formula
  desc "Zero-conf load balancing HTTP(S) router"
  homepage "https:github.comfabiolbfabio"
  url "https:github.comfabiolbfabioarchiverefstagsv1.6.6.tar.gz"
  sha256 "e05f059efdd70dadb3361f7f49daa362363e18bff09a84ef03a37faa8af5fa06"
  license "MIT"
  head "https:github.comfabiolbfabio.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b4794e80f80d6707fe76ce54c0ecd6553a0a7752acb4c8f80d46a1e99a8b8f1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ab1bb05c44eeab89cac0fa7b94a23f791dabbd39f4c90965cfbc9abd3917915b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2895deb038fa2ff206e4f86185ae7300228fee72f911ec055773ce6cc1fe5655"
    sha256 cellar: :any_skip_relocation, sonoma:        "fd70f6058f8f58abb81c915f857500e8e81bf663d23fd0f6f051db209adf69ec"
    sha256 cellar: :any_skip_relocation, ventura:       "fec5578310ae30aae54d81125695c229930c63bc63e508a575a3e452918f35c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d1f86ccafa239e1f6675f0007c1265471f556604c8e4395d125ecd7dc0a7b71c"
  end

  depends_on "go" => :build
  depends_on "etcd" => :test

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  def port_open?(ip_address, port, seconds = 1)
    Timeout.timeout(seconds) do
      TCPSocket.new(ip_address, port).close
    end
    true
  rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH, Timeout::Error
    false
  end

  test do
    require "socket"
    require "timeout"

    fabio_default_port = 9999
    localhost_ip = "127.0.0.1".freeze

    pid_etcd = spawn "etcd", "--advertise-client-urls", "http:127.0.0.1:2379",
                             "--listen-client-urls", "http:127.0.0.1:2379"
    sleep 10

    system "etcdctl", "--endpoints=http:127.0.0.1:2379", "put", "fabioconfig", ""

    (testpath"fabio.properties").write <<~EOS
      registry.backend=custom
      registry.custom.host=127.0.0.1:2379
      registry.custom.scheme=http
      registry.custom.path=fabioconfig
      registry.custom.timeout=5s
      registry.custom.pollinterval=10s
    EOS

    pid_fabio = spawn bin"fabio", "-cfg", testpath"fabio.properties"
    sleep 10

    assert_equal true, port_open?(localhost_ip, fabio_default_port)
  ensure
    Process.kill("TERM", pid_etcd)
    Process.kill("TERM", pid_fabio)
    Process.wait(pid_etcd)
    Process.wait(pid_fabio)
  end
end