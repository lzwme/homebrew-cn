class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.0.tar.gz"
  sha256 "7f7e85cf51497337677748c87376d7f385867fd176c0a1304e3613461d1be7da"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4f31d3a215303202da93e9028784f382408294ca37580eb95d9d23ec852ca36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4f31d3a215303202da93e9028784f382408294ca37580eb95d9d23ec852ca36"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f4f31d3a215303202da93e9028784f382408294ca37580eb95d9d23ec852ca36"
    sha256 cellar: :any_skip_relocation, sonoma:        "bf5c1ef0b139f41b19eca6d7404a5f71c3d869ed6966bb158b4f4e1851873c9a"
    sha256 cellar: :any_skip_relocation, ventura:       "bf5c1ef0b139f41b19eca6d7404a5f71c3d869ed6966bb158b4f4e1851873c9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f5313c6e43701d49b6a5f5d76b7a91d47bdab3733f7d12daaefb32bf751b245"
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