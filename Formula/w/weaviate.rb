class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.34.4.tar.gz"
  sha256 "58096f1108a3844117c30390bcf98c068bf0776095aa8790abf643cbc0f97225"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5d980a8de59fa1dd581d5a801e4c743c2290206a99953c9464e50e8177415ab9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d980a8de59fa1dd581d5a801e4c743c2290206a99953c9464e50e8177415ab9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d980a8de59fa1dd581d5a801e4c743c2290206a99953c9464e50e8177415ab9"
    sha256 cellar: :any_skip_relocation, sonoma:        "dd855b97cee3855c49655b0f811714158c6a00a8299f7dff83e6eff576dd1e94"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "70a8b57779f606035f3e0b619418cb9c109d826087182045baa6cf2925641f98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f5cb6e849677acca577d19905ab4953e7edd35dd556f8941aabfdd67595834f4"
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