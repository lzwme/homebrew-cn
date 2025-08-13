class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.3.tar.gz"
  sha256 "df80804afb029ac0be1319549ffad38ca1abcc82ac45b2f9a713dd047bcd8e49"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7bc03bb8d98deeffa125bd1c4c53b8653c6c50bb196eb9401d4af01f2701ec16"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bc03bb8d98deeffa125bd1c4c53b8653c6c50bb196eb9401d4af01f2701ec16"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "7bc03bb8d98deeffa125bd1c4c53b8653c6c50bb196eb9401d4af01f2701ec16"
    sha256 cellar: :any_skip_relocation, sonoma:        "306e832011a97e845226490aec19415e3e247bcc809b5a18544fe51dc5d4b200"
    sha256 cellar: :any_skip_relocation, ventura:       "306e832011a97e845226490aec19415e3e247bcc809b5a18544fe51dc5d4b200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b2f546154b16dd239582dca7e7e54431b7035d31f49602041d1b04cdea279dc"
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