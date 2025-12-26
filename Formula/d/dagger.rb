class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.19.8.tar.gz"
  sha256 "ff83e6697a783720c16bbc1912fd6dad00df7de30ae81bf688b7fc51520ec76e"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ba9b44b62dfd3f68461a87e8e9fbb26f11be85af355804d1f8ba0475ac75d07c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9b44b62dfd3f68461a87e8e9fbb26f11be85af355804d1f8ba0475ac75d07c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba9b44b62dfd3f68461a87e8e9fbb26f11be85af355804d1f8ba0475ac75d07c"
    sha256 cellar: :any_skip_relocation, sonoma:        "f466c16af997ff47dc961af2e3ba7a91397ad8afd134eab0f6ffd026df0a12b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bcce538d80d40b6541f705ba222194cbf610c5335f8bed84354bc4f1693b4753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9faaab1bf6f7a4c98a48e6a080feb0f14f8b1e8e0117a333d7dd6c9f47071adc"
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