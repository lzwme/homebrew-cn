class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.4.tar.gz"
  sha256 "59fce55513665fd2ad5ffded79cf9b6be4dda65851ddb97c6d7c9af68b7e8c3f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3923b81f2551907866412660a7dfb3bb64818f90f7264c175650804e1acc320d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3923b81f2551907866412660a7dfb3bb64818f90f7264c175650804e1acc320d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3923b81f2551907866412660a7dfb3bb64818f90f7264c175650804e1acc320d"
    sha256 cellar: :any_skip_relocation, sonoma:        "d228f3c6b03783bea281e6bf9f1b692cd64adc4314a176c2025231c5bd9e7dea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8bb03e62481efa48bbcc08f615620138266dd1472b7554979cf6e7437fe7776d"
    sha256 cellar: :any,                 x86_64_linux:  "4332f5742cf64d6133e45fbe29f48aa0a5fab8cedfd4944b1a2754162fc96257"
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