class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.2.tar.gz"
  sha256 "f029250bec2d8e8ddc3bff7ffe28f6e7f5fa36e824b5cfb0eb161e64bc2f413c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f9c588b0ff3ae978bf2bb5b8414c72617f2cfe5ef69477318664b0e38f74668"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f9c588b0ff3ae978bf2bb5b8414c72617f2cfe5ef69477318664b0e38f74668"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f9c588b0ff3ae978bf2bb5b8414c72617f2cfe5ef69477318664b0e38f74668"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ee6945bfe6820e1efa561da6417e36c058c52ef7ac2cc911eb7960ac760a949"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1f5df69a1e793003acf230c2fc84c8583ad0cbfe61d92e10bcd8b6f40476feb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "02ece371c3ce051521eb6a68ed4849af7810ab32a1636c35d7dc4d33d3f26cb4"
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