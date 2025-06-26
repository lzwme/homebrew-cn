class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.31.3.tar.gz"
  sha256 "c11b9a7a1c03c0518d7f5ae381df3534fc6a3fb25e71345c7b2f8153205b1f1d"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b4970e8fe665c4a045840bce5128c0b483dc570f82d1a281c77c4e6ca39cb41"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b4970e8fe665c4a045840bce5128c0b483dc570f82d1a281c77c4e6ca39cb41"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b4970e8fe665c4a045840bce5128c0b483dc570f82d1a281c77c4e6ca39cb41"
    sha256 cellar: :any_skip_relocation, sonoma:        "061625fc101a895913969eea71028b3907c3b2771282913f4ac027759fe430a2"
    sha256 cellar: :any_skip_relocation, ventura:       "061625fc101a895913969eea71028b3907c3b2771282913f4ac027759fe430a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ab893b43af5ff6663dba773840e7d94b9828eaed14e15a275118d39539c5043"
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