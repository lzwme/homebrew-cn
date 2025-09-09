class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.7.tar.gz"
  sha256 "1d66482079121f5c80fc5b3d9d06da2016daaf6c05c60bf39e7366c104eb114b"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c50fffb7464bfc87f3c5a70e331c4578bf04bd45296c021134b834e613f7da09"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c50fffb7464bfc87f3c5a70e331c4578bf04bd45296c021134b834e613f7da09"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c50fffb7464bfc87f3c5a70e331c4578bf04bd45296c021134b834e613f7da09"
    sha256 cellar: :any_skip_relocation, sonoma:        "f6de2da69f4b924236d5a8d8f69a2a69264fd8d302fdaa88eae5231471590eea"
    sha256 cellar: :any_skip_relocation, ventura:       "f6de2da69f4b924236d5a8d8f69a2a69264fd8d302fdaa88eae5231471590eea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4af08894cd376660925bf9932c274655d0e0adee8b682b66ea15466cc243de29"
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