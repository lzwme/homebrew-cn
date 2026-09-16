class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.41.0.tar.gz"
  sha256 "1b5fe650dfca747fe2b90eb34f6be07ab43a36cfc1bedf704255c55ec1179fc8"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "56dbc54c9972477211fb479e24f7bd5721aa1cb27e5a988591c7b9b952c70e36"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "84f7f2f47091950ac54cb1c1b2dc01cd6e5670d6042023c56f56c576a8e09269"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67c3ed4c003e9f613ab4bd7dad066f34c2647f07e456e794b11ad1f697f918e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e886e490e61dd0f6d1ec845775323de2e6605940cf39f114554ec0980a624aa0"
    sha256 cellar: :any,                 x86_64_linux:      "0ab32d5e4908369d99bacdb10cbec3f02ff46f10096cfc41418c1894e80cfd22"
  end

  depends_on "go" => :build

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