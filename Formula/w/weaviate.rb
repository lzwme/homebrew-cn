class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.2.tar.gz"
  sha256 "9180896843a7ef4a402ede413ab205dbbda28375ecfa527460013a278c7f7d81"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7eda1e9d36842e9872be692b58172b5a4fb783e0b1929ec69b731ee37df52bf0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7eda1e9d36842e9872be692b58172b5a4fb783e0b1929ec69b731ee37df52bf0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7eda1e9d36842e9872be692b58172b5a4fb783e0b1929ec69b731ee37df52bf0"
    sha256 cellar: :any_skip_relocation, sonoma:        "802f64a56483b89c8b0d11df1b5b381e03e10e5bcdc8271afcf715f62ef98d87"
    sha256 cellar: :any_skip_relocation, ventura:       "802f64a56483b89c8b0d11df1b5b381e03e10e5bcdc8271afcf715f62ef98d87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6b1952548491dc82dbf92c62f7d33c768c28246ad57fd43dea459ee4ebc026ec"
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