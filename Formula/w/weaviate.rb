class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.35.7.tar.gz"
  sha256 "2004247de9393c77b237719e255446902b3db08dd4a685e460f8a4b66026d923"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58a5dfca1ca6a984e6703594a9fdb6c5863a5e82f6790b6ea057826e35c1d8b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58a5dfca1ca6a984e6703594a9fdb6c5863a5e82f6790b6ea057826e35c1d8b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58a5dfca1ca6a984e6703594a9fdb6c5863a5e82f6790b6ea057826e35c1d8b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d6b3e9c7ce6154f5eeeb31d895fbc8412f2ce58f19692e93b33df6eeaa1f344"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "95c416e91aa5bd23886c97d5604ed6e1b148fe2cca53e144c9d325687b5dcd2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "faa2056bec867b0f32d940639dfc1d68f9e8776e45a614c083ce1132d4f87d6c"
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