class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.33.3.tar.gz"
  sha256 "c626fd8b0d164e4ce5c7c54250f1d501ac8bc18aaf348eb99b4615fa3a6fc5f8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a175d004eeeb423f4b4e18b0cfb7d36b0b2ffb5eb26f62bb4959bb9ba6c91772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a175d004eeeb423f4b4e18b0cfb7d36b0b2ffb5eb26f62bb4959bb9ba6c91772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a175d004eeeb423f4b4e18b0cfb7d36b0b2ffb5eb26f62bb4959bb9ba6c91772"
    sha256 cellar: :any_skip_relocation, sonoma:        "e07ba82cefe26399305292b1737a142b287d5fdc4b8d6589492e64f8db973bec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "322ece4317520ada383060b4bd3f738142b13589a0d2b7d77452fbc2350fdc66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "229ef060dcc7e0bd8797dc67224936ad1ef3235c3163efea5710f6e79d55a354"
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