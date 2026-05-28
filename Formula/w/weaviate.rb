class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.6.tar.gz"
  sha256 "a647fa70a7348221dd0a8924ea491ff9f172e83573e826202106fd9d1d9a01ef"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d1e1e257809f07b82d55f46397aa133bd4dab12ca18698237e8d0fde0cf9946a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d1e1e257809f07b82d55f46397aa133bd4dab12ca18698237e8d0fde0cf9946a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d1e1e257809f07b82d55f46397aa133bd4dab12ca18698237e8d0fde0cf9946a"
    sha256 cellar: :any_skip_relocation, sonoma:        "e794fb6ba4b69354bbddcd37e213451ffb458eaed0417dd4fc1cef0f18817321"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0a5b1ddbb314f5f6ac1b95feb0820525eabde8ca4577d1b6175dfaa1c276f047"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f58a72f2686ed7fae176f4a9c378e5c456ac1140564469be94f94789e2b56a5a"
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