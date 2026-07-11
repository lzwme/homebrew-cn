class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.3.tar.gz"
  sha256 "757ce4b5337bf517fdaf19a2fbb0eb0046257cbbd9c02dc4c05bf17a62ab701c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b91ae51da808ec6bab7f6d7696eb7a2b4bf18daad19270dc1372aacc450e19b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b91ae51da808ec6bab7f6d7696eb7a2b4bf18daad19270dc1372aacc450e19b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b91ae51da808ec6bab7f6d7696eb7a2b4bf18daad19270dc1372aacc450e19b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "ce2f625b95049b34db7df6de121f77ac66492371eec143ca8f05406814e52a6b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eef1a6eed33a9630f637fadd34a99d707d46fd7dc7c2251149e6d3fd0bfe1235"
    sha256 cellar: :any,                 x86_64_linux:  "56aac2304dbe9f6917091074466ac20df3384239bde2dfa4f2b58f25d0489e93"
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