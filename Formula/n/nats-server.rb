class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghproxy.com/https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.4.tar.gz"
  sha256 "a6364f838ace0cf4109e8e67db4793d763b709f7a8c327761aeae44ead52e7fa"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "65d543e935a686479d80680ac31be2f638aafa6f3c72d966002c392f11e399e2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c80c0f2205553cba26b091e1ab713d4bda3e22acfdacbb5b5dc73ddfb9d6d04d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "21d668b817b2553bc91a0a56ec949683f615a264b1fcaf8ab5d3a08ddf5d4137"
    sha256 cellar: :any_skip_relocation, sonoma:         "192f9a5f3be79f1560dffac69a549fb1a8ed8c2e1c3575580235eb375b929e08"
    sha256 cellar: :any_skip_relocation, ventura:        "daed906913bc1ba33a92c2c72c77b90aedea6487f36d3ff0c9d2013ccf9c52cf"
    sha256 cellar: :any_skip_relocation, monterey:       "6218e137115f49b4ec6cb70a46d81e5da892d2d35b239ee09f6ae371982b70ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "759b1efc4ca3009143ecd65ef9c62b9c2ad2c4a79a73589515d4f3361eeb482d"
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