class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.8.tar.gz"
  sha256 "c609b45cd8dea962f193e1a283c0da817ce07a3ca2667b3fe489f16e795021ff"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1d8a33ecc9f8f6bcb735a5f490bf68e2dbd8f6458b54c61f5b24ed037bd55aab"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1d8a33ecc9f8f6bcb735a5f490bf68e2dbd8f6458b54c61f5b24ed037bd55aab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1d8a33ecc9f8f6bcb735a5f490bf68e2dbd8f6458b54c61f5b24ed037bd55aab"
    sha256 cellar: :any_skip_relocation, sonoma:        "734ad860513d2ac0f2fa08b93d9ac84874e4729f9be52cb7a59349e9e0b7e42a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9d3c95e592979027959433bd6513748934d8b0095c6bed9b7c3d382f653a7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "340c8eaeedd305aefa3d1d137510ac33cf5c6b7fa4fb13f56c7b6b866c3c0f79"
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