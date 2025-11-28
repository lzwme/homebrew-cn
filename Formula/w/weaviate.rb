class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.34.1.tar.gz"
  sha256 "7f3c19d7f225a3d85168c09fe519bed2b665977a57f63c7ddffb1551cde4d183"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "857e68046d8734b878acd0bc71fbd341d7dd77a73ec73c940acdb31dadcc5b38"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "857e68046d8734b878acd0bc71fbd341d7dd77a73ec73c940acdb31dadcc5b38"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "857e68046d8734b878acd0bc71fbd341d7dd77a73ec73c940acdb31dadcc5b38"
    sha256 cellar: :any_skip_relocation, sonoma:        "baa7316d1c8c378b178e24e98df54468d166ea10f3b6e3960794aac14ad782a1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "576500db7b84593c0aaae2e6157037ffd295e1f9d63d9d1b77d4aae3d5557e76"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0eaf304d8f1ed69a0cfa011b320298fa038ca4a6cdddf006859e2a6868c6f82"
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