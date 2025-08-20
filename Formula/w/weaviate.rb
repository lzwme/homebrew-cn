class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.4.tar.gz"
  sha256 "3fcf433a458de6a1009356ba7d6cd7f78ddfe60a94cb72a43e926c00048a9960"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2cf44debe0a69f2741fa4773239ebd8c2a58472ffc980565a4ea6f1d2df89e80"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2cf44debe0a69f2741fa4773239ebd8c2a58472ffc980565a4ea6f1d2df89e80"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2cf44debe0a69f2741fa4773239ebd8c2a58472ffc980565a4ea6f1d2df89e80"
    sha256 cellar: :any_skip_relocation, sonoma:        "21039b12dbadf3ea8e2763439a70dc836b3e17b6db5e555a775f6b285e344542"
    sha256 cellar: :any_skip_relocation, ventura:       "21039b12dbadf3ea8e2763439a70dc836b3e17b6db5e555a775f6b285e344542"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8e0cbd8c2630b924f81b38e10adc63ce16e1f74531b0853279d9de5f78026cfa"
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