class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.2.tar.gz"
  sha256 "f882d0f47ba20791756589305dace1f22ccdb210b3c96606c7f61b2f38b7e419"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ef2ff72b4944436ce500e093ce426186499e74dba8bba87db3919f1cd1748f82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ef2ff72b4944436ce500e093ce426186499e74dba8bba87db3919f1cd1748f82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ef2ff72b4944436ce500e093ce426186499e74dba8bba87db3919f1cd1748f82"
    sha256 cellar: :any_skip_relocation, sonoma:        "d2e3efc464e116f1d2b3874d405e8fc81ad4a9ea768311381a4a9fa942654a77"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "84322c7d70da40ccacf5426205824455cb884df467f1e524149565d68553d2aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "84de548db35f21a9fd693a8d0664fbee1c19008e15ea8d7822ac79087c6784d6"
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