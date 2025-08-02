class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghfast.top/https://github.com/nats-io/nats-server/archive/refs/tags/v2.11.7.tar.gz"
  sha256 "62b31c577cec478d9f646f66950c7e3405c270ffcc76cafd4d3a7e59b5f2bb66"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e81846935073dbb18e566c00ae62c5bc35cb70cd4834ab7f19b751e85f2a4cd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e81846935073dbb18e566c00ae62c5bc35cb70cd4834ab7f19b751e85f2a4cd3"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e81846935073dbb18e566c00ae62c5bc35cb70cd4834ab7f19b751e85f2a4cd3"
    sha256 cellar: :any_skip_relocation, sonoma:        "28bd4275cc871d9c72b02239b46e90b6fa2d93396c58b64aba7a31b78b6a329f"
    sha256 cellar: :any_skip_relocation, ventura:       "28bd4275cc871d9c72b02239b46e90b6fa2d93396c58b64aba7a31b78b6a329f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd87b37b33b65bb1dc3cde76b047d9ba2d697a71b50ea20c98503f798324113"
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