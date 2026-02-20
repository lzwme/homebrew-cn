class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.9.tar.gz"
  sha256 "5da431007b17bbb5cab1337f973e5d38b50109fc4e09b55b109c1e8348121c5f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e8bb8aa069bc40dd36e0acf991df99fa9b6fc0758a8a4c8caeb816b6baeec49b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e8bb8aa069bc40dd36e0acf991df99fa9b6fc0758a8a4c8caeb816b6baeec49b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e8bb8aa069bc40dd36e0acf991df99fa9b6fc0758a8a4c8caeb816b6baeec49b"
    sha256 cellar: :any_skip_relocation, sonoma:        "207de60234c88244fe245bbe5b06990b44dc85647a5e40c39ad8d847d34771d0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fd2581b840a7206c5a0cbb5f3a8d12fdc166bf5e8ebde17dcc231c613c794748"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bb0efb529b04bb74fbbaedd13c1ba992f501299a4c45ba1807ee646d6f1c31cf"
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