class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.21.3.tar.gz"
  sha256 "741b1793459b092773530bb5461f67dcc197d389bfb787cbd54fac286a40ff64"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c8f111c2f79603d35bf8d70278ef960fceabe42816f81f666f4b4f01daf0dccf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c8f111c2f79603d35bf8d70278ef960fceabe42816f81f666f4b4f01daf0dccf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8f111c2f79603d35bf8d70278ef960fceabe42816f81f666f4b4f01daf0dccf"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ce68c83b04653cbe14b0dc4fe502b8edd0fc43b5941575fbdc6230d4ac3f520"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "97428d7d17f4b01ade31fcd5cb552aef7c7f757ebc2567b656add8d283c8cbbc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2cb549612bb0cfb6c9607f20b112217f99dfc45c497496856645249f34c67eaa"
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

    generate_completions_from_executable(bin/"dagger", shell_parameter_format: :cobra)
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"

    assert_match "dagger v#{version}", shell_output("#{bin}/dagger version")

    output = shell_output("#{bin}/dagger query brewtest 2>&1", 1)
    assert_match "failed to connect to the docker API", output
  end
end