class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.4.tar.gz"
  sha256 "91738e4c7dc9ee0da86c658aba69bb589689d1b39d7d98c909d80a191541d926"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5fcb83d25c1301800a67b43e9b2bd06c25dc802537be41bd3ca04ff7e069ebd7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fcb83d25c1301800a67b43e9b2bd06c25dc802537be41bd3ca04ff7e069ebd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5fcb83d25c1301800a67b43e9b2bd06c25dc802537be41bd3ca04ff7e069ebd7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3fe960d96f4ab99226e2a79d6316b88500fc5655dcf59ad59a1b84b4ae1db8b0"
    sha256 cellar: :any,                 x86_64_linux:      "18bdda1c92d7ba23c2904a085286b98e814bb6594a40e8a568986e06aae299ee"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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