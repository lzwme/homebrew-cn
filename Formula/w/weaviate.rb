class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.1.tar.gz"
  sha256 "cae8f48f8eb73e75821e5947172adc0004dfde133fcb6e7c0002ddd1f9f83d6b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2714269cde834c86c65d6423acd877f7e97c1770691367f1ef93abe44b7f0026"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2714269cde834c86c65d6423acd877f7e97c1770691367f1ef93abe44b7f0026"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2714269cde834c86c65d6423acd877f7e97c1770691367f1ef93abe44b7f0026"
    sha256 cellar: :any_skip_relocation, sonoma:        "d61b576e57b352a75c64974b4291f19275c97ccf791c70448e0f1acb752eeda0"
    sha256 cellar: :any_skip_relocation, ventura:       "d61b576e57b352a75c64974b4291f19275c97ccf791c70448e0f1acb752eeda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3955df17ce10ea4ab85c3163f79f98220c42eb1601c38ee6562fb102b9c79124"
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