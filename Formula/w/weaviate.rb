class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.39.9.tar.gz"
  sha256 "11e0db9a16ac8db4eaea98921d03f8d26e62fd427ae0361ee49eb6cab60e2ec3"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "843a46464047a0d5a70ffb29e49f76242f73268df520e4b7481a1198e220ed76"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "843a46464047a0d5a70ffb29e49f76242f73268df520e4b7481a1198e220ed76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "843a46464047a0d5a70ffb29e49f76242f73268df520e4b7481a1198e220ed76"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "81bbaeaf1031f2bf25524480ab50267d05f40bf050c77a41f39604ba8a77ff3e"
    sha256 cellar: :any,                 x86_64_linux:      "359a4d6270ecdf88857460785e43c7d5a4125ab42f43a6c3e26baf81ae3b1c57"
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