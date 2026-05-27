class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.21.0.tar.gz"
  sha256 "2173fee33ba858c584e5e459bbb794f7e0822e1edc49f06f929761da34af8905"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b852fe5e5cba29f1b3a63b85a6c6977bc088c6d2469a3b34af1d40769fd6eb82"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b852fe5e5cba29f1b3a63b85a6c6977bc088c6d2469a3b34af1d40769fd6eb82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b852fe5e5cba29f1b3a63b85a6c6977bc088c6d2469a3b34af1d40769fd6eb82"
    sha256 cellar: :any_skip_relocation, sonoma:        "005778b677515b9884550e37944c0e7cfde2d0eddea33a090772f661ec536ffb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ec713a07eb8d63b0bccc9b454cdb2ba7400e8c9ceb7036c146c4dcd6b90b5790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17de820d7346b12382d75b2f2056dd1a923f4f1b1098831b9f7f75659109a7c6"
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