class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.4.tar.gz"
  sha256 "2132aec52d8b52f8204f31dc5c73bd62f8aef06532eefc7664101a8591803c45"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc5f010cdb1858d0f9fd34585e6ab6481b3a7e91521400f71bd1f4a6bd0065c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fc5f010cdb1858d0f9fd34585e6ab6481b3a7e91521400f71bd1f4a6bd0065c7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fc5f010cdb1858d0f9fd34585e6ab6481b3a7e91521400f71bd1f4a6bd0065c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1e7a2764d3677d4233fa538d100433219ea71af5f8e0b78d7d180e98d313433"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "67fe1cca4aa889be9264f7f17de837b988d312739296674af99cf4e4e7526cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5a6759b74dd73157acdc5dad0bb4cc65ca19bef2af036da3185febcca0f41d17"
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