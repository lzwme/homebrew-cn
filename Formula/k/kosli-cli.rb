class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.47.2.tar.gz"
  sha256 "76c6266f62f1cf38723d46c11f5762ff3ee61c13d116e2bd7aa9441f2d27c6e4"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "18de074d9abd87186dff68623778364b13502c397743105f2d65674a01450baf"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ea0ba741984a49f0dfcbd7bf0e2f9a901acb7d10d1e88dcfe9a95aa22b91753f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "50b1a87b7c8b75a1e453d1188f6b872ee2d53fe427fa0c1e6a2d0d6b28800ece"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8aeb512f90a86027847684da8e711e71da6fe9f6d735d4e89e494e09a88f28d7"
    sha256 cellar: :any,                 x86_64_linux:      "9b280bd695ae87b714c0eb76d69d0d1f81e166fc74f6d9b8bcad8da925bb89f6"
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