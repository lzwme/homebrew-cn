class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.33.1.tar.gz"
  sha256 "a6570ab72925269fb790302a3fb1b31dbed66f32f7ea0f1960a2eed134cc25e8"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "014b0d0de79fd0f32f2270892258a521cb1a647574fb402da0b8080ec7076f17"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "014b0d0de79fd0f32f2270892258a521cb1a647574fb402da0b8080ec7076f17"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "014b0d0de79fd0f32f2270892258a521cb1a647574fb402da0b8080ec7076f17"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e70884adfbfa481f3ab79477103978f0977ea914610fffcad2a35975987c654"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c81e46c442ed061627dad1e7119e4742b7e6e367e2685fbe636c8b2d09a33307"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "571f28db4bb11f5acd275038b9c16b5290d48c6189d3743c93014ca8e73ac7ac"
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