class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.40.2.tar.gz"
  sha256 "31b3f81ab191aa410df37551ca1a5ccc8c17171a180192c29d27e467f902e69c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "3a2e0a05ea9262e6e2861f325ff567b340172bea89379c60928456cc93c0d1b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "3a2e0a05ea9262e6e2861f325ff567b340172bea89379c60928456cc93c0d1b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3a2e0a05ea9262e6e2861f325ff567b340172bea89379c60928456cc93c0d1b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "f27f01b4611d15d4e44e2c6f6e01ea3398be8d714dd5dead3762c0371a06c63a"
    sha256 cellar: :any,                 x86_64_linux:      "0cedfb1c861b8ea2fb6e19dcf7826913a852b5cb2e3c6f863b6698774b142bb4"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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