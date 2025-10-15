class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghfast.top/https://github.com/nats-io/nats-server/archive/refs/tags/v2.12.1.tar.gz"
  sha256 "4d06c190294638aed37728f663f59de30b1b7492bb0af1891bccc3647025fc0f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c4b89de8ba160e7ddf4debbf093723ed1ef1c3489d95434f61f02a2c285b93c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4b89de8ba160e7ddf4debbf093723ed1ef1c3489d95434f61f02a2c285b93c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4b89de8ba160e7ddf4debbf093723ed1ef1c3489d95434f61f02a2c285b93c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1f385dac90b5ca5d69700713d64449f7eb53eaec3337d1083e80317f37b1f6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc606fd3ebf534d6a7ce45e572f25842f8722d53b7691772f2d613892513aebe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5dbb541f3c803fab115b768791f3dd32763f517da456e5eddeb4c8f129e4026"
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