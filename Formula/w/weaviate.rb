class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.29.1.tar.gz"
  sha256 "f96022809730cbd8a8b585033b4a68dc90f5c051c777487eb5990a4ca8222367"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b96d12b6a7d77159a0794bb90f1b2e8ebaef821c3572c66eca1ee9b5db260a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b96d12b6a7d77159a0794bb90f1b2e8ebaef821c3572c66eca1ee9b5db260a6c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b96d12b6a7d77159a0794bb90f1b2e8ebaef821c3572c66eca1ee9b5db260a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "63b50069c532e0da78c2eead8dfd59702abd8d84750703c68c55466b9864123c"
    sha256 cellar: :any_skip_relocation, ventura:       "63b50069c532e0da78c2eead8dfd59702abd8d84750703c68c55466b9864123c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b7644d785a5f157fc85d4dff61f2bca407c23b0ebf8e19c0ef3060d8f21d164d"
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