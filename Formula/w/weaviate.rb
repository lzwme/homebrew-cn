class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.30.3.tar.gz"
  sha256 "6680c87953376b72c3325fe2757790fad745ea14e4a6fc78208140edcb5c8462"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9d3bbbda72fa3a140fcc398d59ed75e64fe0704ac42e2f0a8f62b6a13d6a277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9d3bbbda72fa3a140fcc398d59ed75e64fe0704ac42e2f0a8f62b6a13d6a277"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c9d3bbbda72fa3a140fcc398d59ed75e64fe0704ac42e2f0a8f62b6a13d6a277"
    sha256 cellar: :any_skip_relocation, sonoma:        "431b95ebdb73b7eeafbdec3ffba86ecb5d91e69fb3a41763d7e689b059fa734c"
    sha256 cellar: :any_skip_relocation, ventura:       "431b95ebdb73b7eeafbdec3ffba86ecb5d91e69fb3a41763d7e689b059fa734c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd05d35f5a837a0060328885d02f56331bd2c928c799674f72c03b715b1b0c96"
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