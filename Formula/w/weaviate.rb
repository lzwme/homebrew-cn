class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.3.tar.gz"
  sha256 "683af636b37f28b4a35175b542fa8093a3502a555cab5b09338732640c4ec6d3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5f65a93e6048a444d38962cb8d3fbd5da1b0633affdfc60fa6b34d8ec3378690"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f65a93e6048a444d38962cb8d3fbd5da1b0633affdfc60fa6b34d8ec3378690"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5f65a93e6048a444d38962cb8d3fbd5da1b0633affdfc60fa6b34d8ec3378690"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5e8bf4ccca239456768ea792df15fe826ebf20682e30598a3748ebb2f85b3d23"
    sha256 cellar: :any,                 x86_64_linux:  "259680c9d3883eedf3510bc6f1dc7311b31ef324fd0604a2e15f3e7582f11141"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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