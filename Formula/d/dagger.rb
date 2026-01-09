class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.9.tar.gz"
  sha256 "b0afe1ae1b8c8583d129a0acabfefd3232cd4d3aa6719d3832377e44e0e352f0"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1e05996bba3616411eabc3744969d82a8027466ed410d67ef03b3dcfe9ddfeba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e05996bba3616411eabc3744969d82a8027466ed410d67ef03b3dcfe9ddfeba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1e05996bba3616411eabc3744969d82a8027466ed410d67ef03b3dcfe9ddfeba"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dd3a0b6b41aaf25f3b74db97177c5b3c9e2bdd99c3078636a420bb1eda79ac7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d98de3004553068fc9034c6e611c6b3e3a09595fc86023c76f45ec4ee997bc6e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "295d414e54a178bc156944c4de63f30794d8f8ca5bd2abb12a18b49941f89dc1"
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