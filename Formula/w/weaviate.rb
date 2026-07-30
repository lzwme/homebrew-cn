class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.8.tar.gz"
  sha256 "9e86b1907d19ab5be36ed4e95d59bbb9e85e40e1fb823aaaa0e4d3c648a1b525"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a5dbf97c4eae85a0b94180fc0973d54852bbe851b54a552f3258de4c611e3a4f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a5dbf97c4eae85a0b94180fc0973d54852bbe851b54a552f3258de4c611e3a4f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a5dbf97c4eae85a0b94180fc0973d54852bbe851b54a552f3258de4c611e3a4f"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d9b374d2df3bd26a61f9554eb6210279c1884f73d166d56cbbde12dfc4bba69"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "012ae9b2b24dfac3a9a690e959effa3cb9ccb415619f54e4bfd65e13286e1b0d"
    sha256 cellar: :any,                 x86_64_linux:  "5e5994f1f66bbb3ad8c7963c466f05bddb327c62b34042ea54fa74affe068c28"
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