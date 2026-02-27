class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "4266cf6732896282c3c27613455958754ad58342115e3a24abd2cd5aeca2b090"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "91b7f8512847a6871d418e41c36d4e35d1cd7aa65971a9e912b3410f730e1abb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "91b7f8512847a6871d418e41c36d4e35d1cd7aa65971a9e912b3410f730e1abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "91b7f8512847a6871d418e41c36d4e35d1cd7aa65971a9e912b3410f730e1abb"
    sha256 cellar: :any_skip_relocation, sonoma:        "4caa90cdde28d72b56e76630f0537cb853be5f417a96504497cee6f1e93501fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56e9043ece1c08adc7364337b27c92cf40176c549e7f6fc772f042cf58e73fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f344828b5d028ffac0a6d946054c1dfd749045a606c024f81eaf9665edc80622"
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