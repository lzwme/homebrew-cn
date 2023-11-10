class NatsServer < Formula
  desc "Lightweight cloud messaging system"
  homepage "https://nats.io"
  url "https://ghproxy.com/https://github.com/nats-io/nats-server/archive/refs/tags/v2.10.5.tar.gz"
  sha256 "48730850916da1bbdba80732a41c703f743128462a9795cfdb81ceff8d0a641f"
  license "Apache-2.0"
  head "https://github.com/nats-io/nats-server.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2e0db9a7726ec8ad95f6d36750b706ab7eb013f2a4258cd980305053fd0ee03b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2c1ae2c7e8bb08a7aa9a53127e0e0b3555b0b7900608674c473808ef18342e67"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "03f38d6cf06cd277b8b0ace5bdac04d6405725b67486a23e8451d45358b0771b"
    sha256 cellar: :any_skip_relocation, sonoma:         "f685c8cb6ff469e8f709f32e7ff13a948e92d467cfb72f3f5c8741cbbfef1b20"
    sha256 cellar: :any_skip_relocation, ventura:        "d243dc111e62fab94d57ba3a4b90075e8585d5bfa5db4facb2072998301f9574"
    sha256 cellar: :any_skip_relocation, monterey:       "b1749f4fd86cc3ded6dc11dd4cd647703e187f04c34adee92ddc66c476da6f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b8fc76ddc9a2ca5c9b51e8485ba12986b27eb488c2902ebd4ae09830392a6d"
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