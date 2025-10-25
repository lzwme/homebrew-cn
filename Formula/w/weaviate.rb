class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.33.2.tar.gz"
  sha256 "5d23a31792882d6ea99d79373d4045d4d8f1f4353d35ff3b0881cb6dbfeb65cf"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "22668dd27a5d5c344a03852dfc98e8cbb3bf2551e6ae2f5535cdd5738200fb22"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "22668dd27a5d5c344a03852dfc98e8cbb3bf2551e6ae2f5535cdd5738200fb22"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "22668dd27a5d5c344a03852dfc98e8cbb3bf2551e6ae2f5535cdd5738200fb22"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a6e509550a892b7a85e34e61c42d39802f05bd906d3c56e0304de56f2427d8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b362daac6b1052deedb6848cab0d1c305a1b9ce352d8036f9f365c3c5a4fa0ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9170dcb9866aa97d50e5646f81cc9004e16fcea3f30dfe3fb761f66dbf20401f"
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