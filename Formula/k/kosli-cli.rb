class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.50.0.tar.gz"
  sha256 "45fede335fce9268320542f2cd309f154c99289e07c49e12509db8a84b1a21f0"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "b77bc92a9265b5af68642d10652975c344eb0498f5afe813b23f0e17bb72be12"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "52fb5ce6018c044acde29c323ad52a5b069904fef67039476966e9a5fc7a7e68"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "c32b7aef083448fc91fe6fa9e4fdc6edf309fad432092a8e2433eca55c300cd6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a52de94654e103c62ca350e30a8fd4c827906205d59ab0ad4bdbaebbbb09f59e"
    sha256 cellar: :any,                 x86_64_linux:      "fa4d126da5cd1c227f9ad3300536f2d2ea8289a4559b61a8657926513baafd43"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end