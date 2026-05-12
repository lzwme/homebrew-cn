class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.3.tar.gz"
  sha256 "2231c08622ce6cacd9c8c63c4d2bb1f5e69c4d62fb2e8f0ed35e5eecbaa87a04"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5e5f16c47acc568bd1503d00688e3d5a9cd5d11e13eb9d7fb164e16e1543d0e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5e5f16c47acc568bd1503d00688e3d5a9cd5d11e13eb9d7fb164e16e1543d0e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5e5f16c47acc568bd1503d00688e3d5a9cd5d11e13eb9d7fb164e16e1543d0e"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be679beaacdd9746d045ce8f4159e47f7743052791324221b8dffa2d96640ce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e535dc70c53daa8c0b9d752efbc48645ec31b9942b6c9a8de9744775364bc81c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88325cd3b83b7456166ef27738403a5785e81111e3fb266b4716b15439836f59"
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