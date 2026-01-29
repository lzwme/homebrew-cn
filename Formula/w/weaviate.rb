class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.5.tar.gz"
  sha256 "77c1788b95742d7dbe4cfc012d5df4a2c9287cbd5fecc46607daaeadbfa8de3b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1cf49ccc6cd1bca9c1e28d4028532f6f0c2384ad4f4602a2b22bb66abaadcabc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1cf49ccc6cd1bca9c1e28d4028532f6f0c2384ad4f4602a2b22bb66abaadcabc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1cf49ccc6cd1bca9c1e28d4028532f6f0c2384ad4f4602a2b22bb66abaadcabc"
    sha256 cellar: :any_skip_relocation, sonoma:        "63080937c1b288293723148d859bb7d0667641d2cfd6b8919ddef0c11c12494f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d8be95997fc4414cfc3e4cd39f78be3677345f89ea0382e43b4ba95e45a855d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e45f318c72e57099b27ea6f5b3535feef8dffd0812289fde0f4e72922121f20d"
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