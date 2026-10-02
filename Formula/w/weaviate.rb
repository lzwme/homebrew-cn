class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.8.tar.gz"
  sha256 "47e33fd99091fca8097903c151cccfdfd27783892bd0869ba5823bdcbcfe4267"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4696fa4659d5ac257fe89510378b060c89a72961dbd0a7228aa9341ab8b6b776"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4696fa4659d5ac257fe89510378b060c89a72961dbd0a7228aa9341ab8b6b776"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4696fa4659d5ac257fe89510378b060c89a72961dbd0a7228aa9341ab8b6b776"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b0f4141784c1eb80b0b0019eb1b591ebd5239e63f3666fef4c668427412806a8"
    sha256 cellar: :any,                 x86_64_linux:      "0b98d63f4da8db5df628d75e3beb95ced977dc625727de9abe564cdddf0e6f81"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

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