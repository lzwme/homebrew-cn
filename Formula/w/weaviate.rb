class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https:weaviate.iodevelopersweaviate"
  url "https:github.comweaviateweaviatearchiverefstagsv1.28.0.tar.gz"
  sha256 "b2f311239a688cf0bc23764ffd99fa5cbc84ddd946f42f9238bd943061d26eea"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5802601806067d7a69307ce08eb5622de43bf3fb37e84f71eb97a6b31eba9fd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5802601806067d7a69307ce08eb5622de43bf3fb37e84f71eb97a6b31eba9fd0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5802601806067d7a69307ce08eb5622de43bf3fb37e84f71eb97a6b31eba9fd0"
    sha256 cellar: :any_skip_relocation, sonoma:        "55529cf681230869df668a064b0122519d8abcf24d7a478f5a1457ab786e2540"
    sha256 cellar: :any_skip_relocation, ventura:       "55529cf681230869df668a064b0122519d8abcf24d7a478f5a1457ab786e2540"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "15f283bf0ed26ab489bcfe78fec218cc69b7193af95868f849411f03a20d96c3"
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