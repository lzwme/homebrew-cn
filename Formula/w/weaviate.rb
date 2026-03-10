class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.3.tar.gz"
  sha256 "21c874747618c5fc15e362e210b9de50310af902ed4606c4d23eba92fa64f58e"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "acc0a07228327e8f838811abe747353a6adb24e90ee1b0f1081d65c7a4213ee9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acc0a07228327e8f838811abe747353a6adb24e90ee1b0f1081d65c7a4213ee9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "acc0a07228327e8f838811abe747353a6adb24e90ee1b0f1081d65c7a4213ee9"
    sha256 cellar: :any_skip_relocation, sonoma:        "dc0b8d3a8091e55798118d42adc883ff7fcee8dfcccefcc1868e9c8b6f57ff9d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4414735e3a4dc913fc4ad7f4580e83bc9ae5449607dc53136d76756d616d37c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eddcd32375f3d9bcd5b52fcdf5f40359eb1be38b461f54b24d8c34588281a090"
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