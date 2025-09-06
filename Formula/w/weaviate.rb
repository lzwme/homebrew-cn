class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.6.tar.gz"
  sha256 "de44758f162e799caa24187c6fcd0cb9c62e60473ded6a6d5a39f065b3988a49"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21ef3a1ee00b5577da55b9821a01c37ded71a53cf05c172da2a96b59ed1102f9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21ef3a1ee00b5577da55b9821a01c37ded71a53cf05c172da2a96b59ed1102f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "21ef3a1ee00b5577da55b9821a01c37ded71a53cf05c172da2a96b59ed1102f9"
    sha256 cellar: :any_skip_relocation, sonoma:        "59becb37eebc7455dc5644264838cce92c71c72224e46c2cc17f7ee0c618433b"
    sha256 cellar: :any_skip_relocation, ventura:       "59becb37eebc7455dc5644264838cce92c71c72224e46c2cc17f7ee0c618433b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "41b9f089f8996fa6eb47add429b5f413f8d8153bed8d559d24ab71064bd67f86"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end