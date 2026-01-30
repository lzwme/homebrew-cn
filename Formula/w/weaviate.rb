class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.6.tar.gz"
  sha256 "3f79601aed84f58828b4017f9dfa20e1d1d80586d6f3664c2c2b75bd0a50e028"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ae39a775ff4b49eab205674f42a3681ee79fe349eaee6385bc2b8a90d27ec93d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ae39a775ff4b49eab205674f42a3681ee79fe349eaee6385bc2b8a90d27ec93d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae39a775ff4b49eab205674f42a3681ee79fe349eaee6385bc2b8a90d27ec93d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9e66901e6abad4cc18354d43dca75ef4f2350048067b311ba756f8b3709f716"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1433bd6a76c62c55b136f28d9ff0d8f5a910036d7b21c611be44693b52036e11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f978942475e15746f969b3caf578930eaa5ac92477885d4fd9e27980e9fb06c"
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