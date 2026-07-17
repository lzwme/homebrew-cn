class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.5.tar.gz"
  sha256 "27a9b304cc5d3d54268a76b1eec75ad77634f9ce54fbebef7a694fd4017d808d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "445f4e910806639e4f87b20052a3b918c62f7a653de3153d3bbda014ea6dac2e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "445f4e910806639e4f87b20052a3b918c62f7a653de3153d3bbda014ea6dac2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "445f4e910806639e4f87b20052a3b918c62f7a653de3153d3bbda014ea6dac2e"
    sha256 cellar: :any_skip_relocation, sonoma:        "96d722908077d3bcc2e78c34ddccc3cfb0ffd35a10d458ba1937368ea50cb9a5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c483f08f17312c66b7dd301ca6525c94e238dd5a1575109790b9821f9bf8ac5"
    sha256 cellar: :any,                 x86_64_linux:  "9beadf9c915a888aacd7f977eb07e4158fbe45cb50a70746f21683f7fc8c4341"
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