class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.29.0.tar.gz"
  sha256 "2216a5cc572fa2427b1ca637f9c58a34c765cba73bb4728e98d216e1f5ff52be"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d949922fada7a979fcdcf6b350c9e9fd34b894651eb0b14f89d5fe77d452a2e5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d949922fada7a979fcdcf6b350c9e9fd34b894651eb0b14f89d5fe77d452a2e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d949922fada7a979fcdcf6b350c9e9fd34b894651eb0b14f89d5fe77d452a2e5"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1f18ae7d4443e5fbb6433938ada1e3f3cd676d3399ac5e774217a63b3d18df"
    sha256 cellar: :any_skip_relocation, ventura:       "9a1f18ae7d4443e5fbb6433938ada1e3f3cd676d3399ac5e774217a63b3d18df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fbfaa42926805dc7d12d748f0550395415690b460eea0dce7e402d1914b43ba"
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