class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.0.tar.gz"
  sha256 "2dded67225a8241685d174e81e449574b61a511d0d79f4331de04e8eb4c95ec1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "21a5bce3b99663026f614e8f5a1d66c358758f78fe35bc623dfbbf454ee9b812"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "21a5bce3b99663026f614e8f5a1d66c358758f78fe35bc623dfbbf454ee9b812"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "21a5bce3b99663026f614e8f5a1d66c358758f78fe35bc623dfbbf454ee9b812"
    sha256 cellar: :any_skip_relocation, sonoma:        "699a527e3afbc2a7d263d4cfe6bf92c94b5df4e434e8c5df9bb4fc515de19722"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "87565e79ff998dff32718904e513a38937b4a4460e704a65f0026a6fae47db0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c11791cd9882fdf3a04bed2f01a6b84974a8b0ab8b2bf401be275e4fc8a18a10"
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