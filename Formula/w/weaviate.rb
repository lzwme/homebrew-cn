class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.31.4.tar.gz"
  sha256 "dd73987522baca04b0075b5c022b7adebc65a02639adab053166e5d15e28324c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "87075eb1cb2940cb8c74abbd037799c74892e50059d03ea84f5f43e9515b96f0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "87075eb1cb2940cb8c74abbd037799c74892e50059d03ea84f5f43e9515b96f0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "87075eb1cb2940cb8c74abbd037799c74892e50059d03ea84f5f43e9515b96f0"
    sha256 cellar: :any_skip_relocation, sonoma:        "83991812df903ab4e0628486939ce1aa0fc25f59cda22c658d7dc49195e60d8e"
    sha256 cellar: :any_skip_relocation, ventura:       "83991812df903ab4e0628486939ce1aa0fc25f59cda22c658d7dc49195e60d8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6268825cdf9ae8e7aa73fe369040c0848f8fe1837f379d95648fa1e4de732061"
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