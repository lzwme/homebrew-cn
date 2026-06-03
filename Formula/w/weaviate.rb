class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.7.tar.gz"
  sha256 "9ce9bacd602c89f3e9c8f66fbf38500d7a693c29118f6605742976011778e29e"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a302e0f9c2e97bb1a05aa87db45b660086faf2f36af8904922298d2ec0a2778f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a302e0f9c2e97bb1a05aa87db45b660086faf2f36af8904922298d2ec0a2778f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a302e0f9c2e97bb1a05aa87db45b660086faf2f36af8904922298d2ec0a2778f"
    sha256 cellar: :any_skip_relocation, sonoma:        "930bf830d2500d248e461a800ddd683a07e209194f0a8df573dee49306345dc6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a91b506debdc3fc74415726207fb508094dc4a35a8dda026f0459b7e6bfc12"
    sha256 cellar: :any,                 x86_64_linux:  "4c07de6c955623b55346c6aab13269c50ed47b50791c889c9eea2e5ec6a575a1"
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