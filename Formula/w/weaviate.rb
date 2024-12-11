class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.27.8.tar.gz"
  sha256 "8549781bf1e541dafff28f860bd96080c8544693bd135e39fe37d7d854b5999d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f8ab5aa4c27a35e7a82aebb938b171b6229441037ec6e8e5aaa9e03eb6083498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f8ab5aa4c27a35e7a82aebb938b171b6229441037ec6e8e5aaa9e03eb6083498"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f8ab5aa4c27a35e7a82aebb938b171b6229441037ec6e8e5aaa9e03eb6083498"
    sha256 cellar: :any_skip_relocation, sonoma:        "9dd0477b886b90520daea7dbd039198440e58291fd3fb10c6af762f554bc57dd"
    sha256 cellar: :any_skip_relocation, ventura:       "9dd0477b886b90520daea7dbd039198440e58291fd3fb10c6af762f554bc57dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "766306e236ea56bdbc5672ca0d93004bc1f6e8081520d68c22022154067f8ad4"
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