class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.30.6.tar.gz"
  sha256 "ecb14c3afde0ec7316e705b29c79e8d0711d3e0ccfdd95cb627b9ff90077faff"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db488fd76007cced169ddcbdfc34cdd7bb6f381c56a71375ae2630f15c521065"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db488fd76007cced169ddcbdfc34cdd7bb6f381c56a71375ae2630f15c521065"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "db488fd76007cced169ddcbdfc34cdd7bb6f381c56a71375ae2630f15c521065"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dd9d62044256b42a13042f38ebe8c121b2933358a331f5860b62b4e550d8973"
    sha256 cellar: :any_skip_relocation, ventura:       "2dd9d62044256b42a13042f38ebe8c121b2933358a331f5860b62b4e550d8973"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2605a48ca508d79d6afc8740ed4be9ec96007c0f151074244fadc4e51d03c929"
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