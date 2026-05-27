class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.37.5.tar.gz"
  sha256 "2044c8cf0f29938801eab103664b9c8ffcb4ce7d9466206bdb7e20cf7b3231a9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "59557c5b75593649331752c42d2920767975ca1c32fd66c51062abca2e46b205"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "59557c5b75593649331752c42d2920767975ca1c32fd66c51062abca2e46b205"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59557c5b75593649331752c42d2920767975ca1c32fd66c51062abca2e46b205"
    sha256 cellar: :any_skip_relocation, sonoma:        "c376fe39be14923f1ef861bb456836cbdb0e9f45daf7772f33051fd67533d8e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f95a49067df4a54aa266ba1aa4fd054741bcec07e7bb8cd4e9498c6a50ee293e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be4c9a882b8eeab404cc82cd1c64098fd6d1b7e277a34f37ef4ca905ff6ffd22"
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