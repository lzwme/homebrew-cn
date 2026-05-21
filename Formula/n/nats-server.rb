class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghfast.top/https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.1.tar.gz"
  sha256 "5543bd3757c596994d116986a99965b3b2d61a416f24dd98cefde91c094c102e"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f03a053963108fe99c0afc50ec1dcb4305702d6b363fcf62ff5cae03d592b465"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f03a053963108fe99c0afc50ec1dcb4305702d6b363fcf62ff5cae03d592b465"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f03a053963108fe99c0afc50ec1dcb4305702d6b363fcf62ff5cae03d592b465"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee5538ad59866441cf234f1a5bf2861540e91f3c26a55c2b6166ec2e470318ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8566e99da2eb850615c5cb42d49e00b7fecfd14a3930cd28c705b14a34840266"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb974aa35e449eb734bab4fe7eec8fd04a15dc71a6c50d6d511cf9e975688965"
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
    spawn bin/"nats-server",
          "--port=#{port}",
          "--http_port=#{http_port}",
          "--pid=#{testpath}/pid",
          "--log=#{testpath}/log"
    sleep 3

    assert_match version.to_s, shell_output("curl localhost:#{http_port}/varz")
    assert_path_exists testpath/"log"
  end
end