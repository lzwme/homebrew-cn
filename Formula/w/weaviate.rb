class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.34.3.tar.gz"
  sha256 "84d19e82d890ac4e61b4b25026652809b07bd77e7af5ae23c7ef4300cb92b00c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "556a0923737bc0c243e43d64dc9ede800f733d2039b58841eb28bd2dc14a4028"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "556a0923737bc0c243e43d64dc9ede800f733d2039b58841eb28bd2dc14a4028"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "556a0923737bc0c243e43d64dc9ede800f733d2039b58841eb28bd2dc14a4028"
    sha256 cellar: :any_skip_relocation, sonoma:        "85c3e24278580f04acf1f69dda2e2b5a7ea159f76a95dc81c7b53156dbf05686"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a63c369ab5190df1a97a79e423ce1cd54f0f5921fe06982eec5a225aaeea16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4ea0d1e04cf69fb87342f0f5f9fc1e2ca84ee780a0e12057d2055798c0b3117"
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