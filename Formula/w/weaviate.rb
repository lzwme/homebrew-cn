class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.36.7.tar.gz"
  sha256 "ecbce8fc6dab239662dc73087a063d8200c7401e2b6307804df181f45003c503"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "efb4ef9da6e79f0c36ee314daa609dcd9e02a54428ae6ebb82d9431b95bd7eb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "efb4ef9da6e79f0c36ee314daa609dcd9e02a54428ae6ebb82d9431b95bd7eb8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "efb4ef9da6e79f0c36ee314daa609dcd9e02a54428ae6ebb82d9431b95bd7eb8"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa3d858c9f4203c5b68dbfd49b1549a3daf9d0e751217ba125d29e6acafba554"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "692575c01bd6414501477ef71aba79b5cdc903dcd4ecac406b84499d4b436d28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a1eff86148f1989dc06475151d422e41d546537ada81cdd9001119042a74bdda"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/weaviate/weaviate/usecases/build.Version=#{version}
      -X github.com/weaviate/weaviate/usecases/build.BuildUser=#{tap.user}
      -X github.com/weaviate/weaviate/usecases/build.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/weaviate-server"
  end

  test do
    port = free_port
    pid = spawn bin/"weaviate", "--host", "0.0.0.0", "--port", port.to_s, "--scheme", "http"
    sleep 10
    assert_match version.to_s, shell_output("curl localhost:#{port}/v1/meta")
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end