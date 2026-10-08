class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.40.0.tar.gz"
  sha256 "065cd5cd17285d23cef5ddd6c932a22e9316e06f1942132850a0c0febb418ac0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ad00a3f43d683eb1a38865a750fecc290b9c217c6d680da9ab038437492c107e"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad00a3f43d683eb1a38865a750fecc290b9c217c6d680da9ab038437492c107e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ad00a3f43d683eb1a38865a750fecc290b9c217c6d680da9ab038437492c107e"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "6221bee7baf6784313024c6d995fa8c84ecc3aae0a84115572c5b9fcabba158e"
    sha256 cellar: :any,                 x86_64_linux:      "26ec902cdcb0cd09920dbebc4f44f3857fbb48213295442737ad93b701491178"
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