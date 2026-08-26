class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.1.tar.gz"
  sha256 "339dd8b685adf94c271378645631f0ab8c8cad8b1f788761f1708144fcef9353"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "56c5490791efb981af1f3a9498261fee69483a90f97d54417966c8442111b8b2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "56c5490791efb981af1f3a9498261fee69483a90f97d54417966c8442111b8b2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "56c5490791efb981af1f3a9498261fee69483a90f97d54417966c8442111b8b2"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeb226aece7fa5c1b10d745ad01fd29abf1e8cf05980502ffccf66b31388812b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "faf28cfe7af8f9fb9d267ca51309c09d6b36ba8adbececd52cab8b89d3bb544d"
    sha256 cellar: :any,                 x86_64_linux:  "6d4324c52fe1474f688258d432e04eec6d0003189a3f0176d0a4851f7e6499ae"
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