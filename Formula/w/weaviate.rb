class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.33.4.tar.gz"
  sha256 "51af532973c942560235977840b78f5b2693f1a8db1079472467c24cb2514137"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5e726e5a8b80276f780e4943ee6a502f4f9a22a7f92992038e6a845aa8ee239e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5e726e5a8b80276f780e4943ee6a502f4f9a22a7f92992038e6a845aa8ee239e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e726e5a8b80276f780e4943ee6a502f4f9a22a7f92992038e6a845aa8ee239e"
    sha256 cellar: :any_skip_relocation, sonoma:        "43aba757db578e79c8ebbaa1d7238f6e20ee4a2154ed5c5cf2f96dd546670868"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aa177f3a2e5ec507639ec6300be94ed67f3561ad54e6eccff8f06bd00eb345ad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bec95b5acfeb7b5bfd2851cc185744b45f857eb634e452856e688c49cd75d1bf"
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