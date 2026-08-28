class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghfast.top/https://github.com/nats-io/nats-server/archive/refs/tags/v2.14.6.tar.gz"
  sha256 "90aec2c35eaa94105354cbcdfb6d88cea5082415dc39409efdbe320fb66328bb"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bbd2d1adbb10e0e8391bf06bd18188a6b19e3ce2ee20ec67bb05afdb10da5908"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bbd2d1adbb10e0e8391bf06bd18188a6b19e3ce2ee20ec67bb05afdb10da5908"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bbd2d1adbb10e0e8391bf06bd18188a6b19e3ce2ee20ec67bb05afdb10da5908"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "25378171785a7ce9f3b8608041e79bd83a7c4251306ff90c361b842786746c0a"
    sha256 cellar: :any,                 x86_64_linux:  "a783565630fb0ed34add03db68fb044c249a8f4d28483af4b9e7aaedc380fcfb"
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