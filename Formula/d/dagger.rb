class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.21.1.tar.gz"
  sha256 "a4fd0c1fde531a2b1e917019599a41824929992b10ebaf41b596bdd55165847f"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8590ef3bfc0d2651c5abcb61e556bed9479fd295a663f99147e84211ebe92226"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8590ef3bfc0d2651c5abcb61e556bed9479fd295a663f99147e84211ebe92226"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8590ef3bfc0d2651c5abcb61e556bed9479fd295a663f99147e84211ebe92226"
    sha256 cellar: :any_skip_relocation, sonoma:        "cb3eb2c24a674cfea88f80ac88e9d5471b3a21f47d9c0780fbbed0fc4594be4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a8e3c517aa4fdbc6ca3543ebba54c0d4bcacc778d7bebb3cfd45919b60e364f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd03ec7a3322c0ec0073679e386826f93ac44fe3ac602cb66595d58742d2452c"
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