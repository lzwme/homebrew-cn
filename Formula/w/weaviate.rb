class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.10.tar.gz"
  sha256 "56a0502fe6af13e61b5f96be38d7525dbf73bed57de8bff8898cb8c54ffc3390"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "1d1954878058c86502ec933c5655e9f16660e65f29b22e476ff8a1ccb2bfb309"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "1d1954878058c86502ec933c5655e9f16660e65f29b22e476ff8a1ccb2bfb309"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "1d1954878058c86502ec933c5655e9f16660e65f29b22e476ff8a1ccb2bfb309"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0ab9439686de8e2694ddf690455c47174b22dc9332aaeb3305273eb400397588"
    sha256 cellar: :any,                 x86_64_linux:      "53f632bcccf903eb1729c60a482ddd3542ff9c9b73236273be42611211b048d6"
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