class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.4.tar.gz"
  sha256 "f64bfca14f19787345182c74d2a5c6144591f7afa5b0d3212aa968f6ffd9226f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c5a702ad6bda53a7056137b08d80e86e0fc9026d2d1e6d193a35315f39cfaf0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3c5a702ad6bda53a7056137b08d80e86e0fc9026d2d1e6d193a35315f39cfaf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3c5a702ad6bda53a7056137b08d80e86e0fc9026d2d1e6d193a35315f39cfaf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "7b77012c5c9ca6f32e9d5e10de8d01d69c84d907490ccf5b42601d65530f8648"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1e4290c98bab2d8b0648f22a84e5d3aa2533560b23a4dffdfbf94960c706c16b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f1a5572123dd313e07dd70a0ba13dfbe0d8e6593abab8209e37058d86638ec"
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