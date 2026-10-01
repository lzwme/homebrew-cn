class Dagger < Formula
  desc "Portable devkit for CI/CD pipelines"
  homepage "https://dagger.io"
  url "https://ghfast.top/https://github.com/dagger/dagger/archive/refs/tags/v0.21.10.tar.gz"
  sha256 "4177831173a91b8269ca3269d53767fb0b4217d181cdb293612a14ce2f948da0"
  license "Apache-2.0"
  head "https://github.com/dagger/dagger.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b1e595e724012d82d73fe3e8f9d86eec7240d16ae7c9f198440dfb7e985c663c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1e595e724012d82d73fe3e8f9d86eec7240d16ae7c9f198440dfb7e985c663c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "b1e595e724012d82d73fe3e8f9d86eec7240d16ae7c9f198440dfb7e985c663c"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "0fa7333d189b23c7ee792fd7ce711c2dd314c046f0c0e4e1868ac914fd83c797"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5daa72b75084541db92ee7904a8dc8db141a6bd2e3d2e4a55803c2633a38ca19"
  end

  # TODO: switch back to `go` when x/net is bumped past v0.54.0 (broken with Go 1.27)
  depends_on "go@1.26" => :build
  depends_on "docker" => :test

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ENV["CGO_ENABLED"] = OS.mac? ? "1" : "0"
    ldflags = %W[
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