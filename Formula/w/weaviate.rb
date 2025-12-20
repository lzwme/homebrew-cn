class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.1.tar.gz"
  sha256 "8fc335feffa9db88ba41e444d7a52feba28a1853692fd9499d0fe888c435c227"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5430961c51b92a3e1fd8ec26ca64f50827dd32494e9183fbbf0c4f9b91c31da1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5430961c51b92a3e1fd8ec26ca64f50827dd32494e9183fbbf0c4f9b91c31da1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5430961c51b92a3e1fd8ec26ca64f50827dd32494e9183fbbf0c4f9b91c31da1"
    sha256 cellar: :any_skip_relocation, sonoma:        "2a3d10855fb03b36bc6fd5a698499c78076294a67f280d58ac29a1ecd4066df4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cc697d9fc1b52197e57a936fcdb4ddd71674fa283b87b6cb1d55d67832917da6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e8df00c0f562f6f64f93d329ba23bf8bc13b231f033b4b1a7086657d1750124"
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