class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.1.tar.gz"
  sha256 "ed7e8848e3523a01d923b78ba3d0fa662a873ba301105094fdc20254460a76ae"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f17228744e0b9a66c36534088d3c92a280ce0513f4d32130e14aebc75bf23f76"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f17228744e0b9a66c36534088d3c92a280ce0513f4d32130e14aebc75bf23f76"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f17228744e0b9a66c36534088d3c92a280ce0513f4d32130e14aebc75bf23f76"
    sha256 cellar: :any_skip_relocation, sonoma:        "aef7082a8707d9de58514f263eeb8600c043fdbddc979d055dcd334ee3d52dd9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "938fd9c87bc348bee435bb627d7015d9fb91f3a03ef7515fc05d20ec194a2def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b9b9a4fd769a7ea248fdf18ef8be70e029a4ba12e9f5f06946570ae3813adb"
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