class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.18.16.tar.gz"
  sha256 "b5a312f6396c02cfc7f0fc8cb11c96123dfcf0bb1baf184cec62a9dddd641a92"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "58e8f51d2e3ae6ea8354d860475dea38828f5b0465b1b8bda001c35edb81268b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "58e8f51d2e3ae6ea8354d860475dea38828f5b0465b1b8bda001c35edb81268b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "58e8f51d2e3ae6ea8354d860475dea38828f5b0465b1b8bda001c35edb81268b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1eaebb8b16273a6342083c8e44c173fe337ca292dfa7af4779153fd50019712e"
    sha256 cellar: :any_skip_relocation, ventura:       "e9d5901d9d3e00989769c27b781b458fce3fc28ab70382285d33a27212ee63d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "086264def5a43f5a8a203eddcb33615d998069dcad30125eb26d776a2bd1af2c"
  end

  depends_on "go" => :build
  depends_on "docker" => :test

  def install
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