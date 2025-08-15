class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghfast.top/https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.8.tar.gz"
  sha256 "957ec915c35f232ecb497e9f744a8c0948a187a049d4ad1ecf00ae2bfa763650"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "559341196f642d954edf78259bdbf970ff9ab01e030ff9dba2415715e38a4e48"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "559341196f642d954edf78259bdbf970ff9ab01e030ff9dba2415715e38a4e48"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "559341196f642d954edf78259bdbf970ff9ab01e030ff9dba2415715e38a4e48"
    sha256 cellar: :any_skip_relocation, sonoma:        "94b90a1dbf397109099261b25ec2c6f134ce2c8e042515a29645a1be7499c336"
    sha256 cellar: :any_skip_relocation, ventura:       "94b90a1dbf397109099261b25ec2c6f134ce2c8e042515a29645a1be7499c336"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "991e4c44576280b91f95dbaf85a5bf6cf467892fe7cd16a19f1fe10a1471d141"
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
    assert_path_exists testpath/"log"
  end
end