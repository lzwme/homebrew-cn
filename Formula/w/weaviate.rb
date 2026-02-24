class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.0.tar.gz"
  sha256 "a6a46cf0fc10e79b59e627869429bc2b94ecc3cf6bcde18cfae7ae2e8cbc8560"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "af7af94af7a374ac0c06d0337ff47ecb4b7b2c92e0db0bdee1572f957a13a06b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "af7af94af7a374ac0c06d0337ff47ecb4b7b2c92e0db0bdee1572f957a13a06b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "af7af94af7a374ac0c06d0337ff47ecb4b7b2c92e0db0bdee1572f957a13a06b"
    sha256 cellar: :any_skip_relocation, sonoma:        "19c21e683c4c7fa01a3b48d84ce992a32230d231be0740daf3a203531ff2e49c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "93ee4139c921c844ccadf66c7e4b272737cd671336756f15b66f667d8458f87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d05db1f15042a08f2d35b01b91ec22e6773b2fcb486815fcc640dd997b61195f"
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