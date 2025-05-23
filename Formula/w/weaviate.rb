class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.30.5.tar.gz"
  sha256 "d5978413c5cb2b0135f482b4a9c271d16b0dc00622f02c3b0ac10ab0c529fe10"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a60828713f741a2dd916e08f7777e88b4e00e248d742631e373f558732e7840a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a60828713f741a2dd916e08f7777e88b4e00e248d742631e373f558732e7840a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a60828713f741a2dd916e08f7777e88b4e00e248d742631e373f558732e7840a"
    sha256 cellar: :any_skip_relocation, sonoma:        "846b8ff8ae3edf2ee71b4ffcacedaf90a16c17cc42ae98cf5e860dba896a5859"
    sha256 cellar: :any_skip_relocation, ventura:       "846b8ff8ae3edf2ee71b4ffcacedaf90a16c17cc42ae98cf5e860dba896a5859"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d2681c6561febfecf6fc0abf1d22cb4845436c82b6bbd648adb00fe93eedd27"
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