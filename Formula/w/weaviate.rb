class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.29.2.tar.gz"
  sha256 "2982abe3527f515c304e46ea626c6d47f82ff02bacd42890e727b17a00d20121"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "933adf228dce704f452d5076c484e570dcaaaa29670ca9ef31caf4f3934f6a5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "933adf228dce704f452d5076c484e570dcaaaa29670ca9ef31caf4f3934f6a5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "933adf228dce704f452d5076c484e570dcaaaa29670ca9ef31caf4f3934f6a5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "440898a8ca4c17b61338c5d4d0062c698eb0caa2c5b2ee2f6dd6d3f34e6ed9b2"
    sha256 cellar: :any_skip_relocation, ventura:       "440898a8ca4c17b61338c5d4d0062c698eb0caa2c5b2ee2f6dd6d3f34e6ed9b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c80d296af71994063ba71bfab74755f169b06d62c1bf291fca7757ef661ddab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comweaviateweaviateusecasesbuild.Version=#{version}
      -X github.comweaviateweaviateusecasesbuild.BuildUser=#{tap.user}
      -X github.comweaviateweaviateusecasesbuild.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdweaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}v1meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end