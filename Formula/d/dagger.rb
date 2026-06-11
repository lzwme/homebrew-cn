class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.21.5.tar.gz"
  sha256 "3faf7e1ffb033791c71efa60b32f6e41ce178b0980dca5e9621820f84bbffc5b"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cef82a1085a51845097d8701823e99a5949bb652b14508325e2ad65b0cff1caf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cef82a1085a51845097d8701823e99a5949bb652b14508325e2ad65b0cff1caf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cef82a1085a51845097d8701823e99a5949bb652b14508325e2ad65b0cff1caf"
    sha256 cellar: :any_skip_relocation, sonoma:        "af61973c90bec13f6f182d080d62cf96794979544b0b200f9c099abdf8f45408"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efc5ce85458ed880203ece39c379fad385332c1762c46f6cf7da0e3f4e30bca3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2b03801b2e3c6c8007dda4e6873f87f2ee39ea6e456f1cbcfe962800944925dd"
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