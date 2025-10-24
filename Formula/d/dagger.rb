class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.3.tar.gz"
  sha256 "182f2ca8beff01ee55dc6f6c6c0049263b16d307a94ef4b95b0d5ae308f76f07"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c1a54a45bb679f5741c1e142d9075bf2c4047a0b2e36efb3ef72873319c8708"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7c1a54a45bb679f5741c1e142d9075bf2c4047a0b2e36efb3ef72873319c8708"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c1a54a45bb679f5741c1e142d9075bf2c4047a0b2e36efb3ef72873319c8708"
    sha256 cellar: :any_skip_relocation, sonoma:        "b57cdfe9730a5724220f136bac792b4c9dfc038aa9c0279a89f2267ee1e62f2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1965001968144730b909f1cbce177b8ce7c25fb52a269b451fb46edbca324fbf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bc46ee6f2b39a82ed43d04cdf600fd654d5380052eba71399551609cea18b64b"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
      -s -w
      -X github.com/dagger/dagger/engine.Version=v#{version}
      -X github.com/dagger/dagger/engine.Tag=v#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dagger"

    generate_completions_from_executable(bin/"dagger", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "Cannot connect to the Docker daemon", output
  end
end