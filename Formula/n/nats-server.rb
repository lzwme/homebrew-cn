class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghfast.top/https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.4.tar.gz"
  sha256 "fb873897f826686dc4407112613e80c61fba10a1b381375458784995cd9f295d"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "550e97843bcfb950d38ade92dbd6c8cba09c7eb29a9b95be7bafc95cbb4299da"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "550e97843bcfb950d38ade92dbd6c8cba09c7eb29a9b95be7bafc95cbb4299da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "550e97843bcfb950d38ade92dbd6c8cba09c7eb29a9b95be7bafc95cbb4299da"
    sha256 cellar: :any_skip_relocation, sonoma:        "6adc8f0a6095cb20ac78bd7bb8cb39ccc30a73208cbfb51f93a0b17e33c02967"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d56f68748b0720b4c3c4d5a24022900091c3e1b64ba0c892856d226c606434fe"
    sha256 cellar: :any,                 x86_64_linux:  "65ea2bdf6546e725f4a7b498210edd60bb37fbb1b4826f5cdafb4acec15be02e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
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