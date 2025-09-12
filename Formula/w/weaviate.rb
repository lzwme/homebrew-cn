class Weaviate < Formula
  desc "Open-source vector database that stores both objects and vectors"
  homepage "https://weaviate.io/developers/weaviate/"
  url "https://ghfast.top/https://github.com/weaviate/weaviate/archive/refs/tags/v1.32.8.tar.gz"
  sha256 "61f31049aefdb96db61b8113cae6710761ad27d7679e96a50aaa89804b3e51fd"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec75d19a398e781637479f3b4c3d2f7f45f14139ae46307558fa37b1d6d6654e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec75d19a398e781637479f3b4c3d2f7f45f14139ae46307558fa37b1d6d6654e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec75d19a398e781637479f3b4c3d2f7f45f14139ae46307558fa37b1d6d6654e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ec75d19a398e781637479f3b4c3d2f7f45f14139ae46307558fa37b1d6d6654e"
    sha256 cellar: :any_skip_relocation, sonoma:        "df578cc4dfb57cda7ab6b9d16fd32c60788325cc08eeb410d02a8746b4ae849d"
    sha256 cellar: :any_skip_relocation, ventura:       "df578cc4dfb57cda7ab6b9d16fd32c60788325cc08eeb410d02a8746b4ae849d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ffea6126bc801f8aeb09b39a41ec63bcae61c6128f601d32a68d6be617086430"
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