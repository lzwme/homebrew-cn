class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.5.tar.gz"
  sha256 "df72aa052e4470bfc35e21d653711b367fb6c9ceeae6712804ffaac97b591472"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1c26c19d23befc4c70300338ce7b61f5000b4b1ede39aec31a1fefeca74dda5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1c26c19d23befc4c70300338ce7b61f5000b4b1ede39aec31a1fefeca74dda5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d1c26c19d23befc4c70300338ce7b61f5000b4b1ede39aec31a1fefeca74dda5"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a9a07663789bb41318e4a38cf9f6dd15c5b5d92e7ecfa413fe3106ad46c23e5"
    sha256 cellar: :any_skip_relocation, ventura:       "6a9a07663789bb41318e4a38cf9f6dd15c5b5d92e7ecfa413fe3106ad46c23e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "97ce7f4f2af469755a146c0fbeefa109915ab96eac59b118b632bce0952ba154"
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