class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.38.7.tar.gz"
  sha256 "1d3fffeb7471f5a925c37d73922b8b107944ff29b1689f7f6624a004a03ea212"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c6f8911d37c78a020a73d5bc6d9f88d10f1019af2272279990cdbae26d0e4c8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c6f8911d37c78a020a73d5bc6d9f88d10f1019af2272279990cdbae26d0e4c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c6f8911d37c78a020a73d5bc6d9f88d10f1019af2272279990cdbae26d0e4c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "f86b0f17cf89ddee4264d84bb8f3c4f859ae67d6511e17fbfcc620b20c2f9079"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16a9ea97e5c624afeec51b83bcaf0cd118c2e1039cbb18a5fd8f01198a43827f"
    sha256 cellar: :any,                 x86_64_linux:  "d1080089004c2e77be007bc012f97c343f6206e0281ebc702a76e05843f342aa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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