class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.31.2.tar.gz"
  sha256 "a3916c695848aa093f97a3c194c85660d458a014ac0a790a7c1a105229bb1e12"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32d83de3e0b1f9cb26a392e8c1e6e81a3efaad993bb28624ab922c103a9e4c5f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d83de3e0b1f9cb26a392e8c1e6e81a3efaad993bb28624ab922c103a9e4c5f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "32d83de3e0b1f9cb26a392e8c1e6e81a3efaad993bb28624ab922c103a9e4c5f"
    sha256 cellar: :any_skip_relocation, sonoma:        "c1b226dae4aba57fea41e6fcc59c7653873a3b37a11008ce605c88bbb6259000"
    sha256 cellar: :any_skip_relocation, ventura:       "c1b226dae4aba57fea41e6fcc59c7653873a3b37a11008ce605c88bbb6259000"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7af4614c3be8a7aa6089f907f93dbbf39b1afd7a6e758d6b1826576f08d5373"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comweaviateweaviateusecasesbuild.Version=#{version}
      -X github.comweaviateweaviateusecasesbuild.BuildUser=#{tap.user}
      -X github.comweaviateweaviateusecasesbuild.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdweaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}v1meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end