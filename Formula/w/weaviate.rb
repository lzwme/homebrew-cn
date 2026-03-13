class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.5.tar.gz"
  sha256 "9a098ab17ef61d03619a72c9748be16c6d86df06921bc4db500187f981ecbf2c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "526898b33037b3d543709677920ac305494384ccb4224613386a2c22bad1b9c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "526898b33037b3d543709677920ac305494384ccb4224613386a2c22bad1b9c9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "526898b33037b3d543709677920ac305494384ccb4224613386a2c22bad1b9c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "0fea07cb8450d468a171cb289ae9a736efdaf0c80aacace7771a781574fc7f2b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dc6d871fd5e99f2834bf2b4c31975ec8ff944115b07b74665d4b56752f2b7230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2584d7dc3b2dea8eaa6090e7d6eb600123342cf9fbf6645235a6263d40a13605"
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