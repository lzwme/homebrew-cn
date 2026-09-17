class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://ghfast.top/https://github.com/kosli-dev/cli/archive/refs/tags/v2.42.0.tar.gz"
  sha256 "a34be3ee1bb0ac3dca5bab300d6778e6a65f3e07ff4e9c51aa169409beeede7f"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "83a703ab359b80748604cd5a6c8357e40df0136aa096b04d1d3cb318085dfe24"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b8741ccff2b7ac3bee89b8de0f9d6a9efb503ebed8fef79fb4868a41dc9a2489"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "6985d7440f7a50a18bf1a9e1939e4d43858e372572cca57e287aec0ea5f6851d"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "adfecd0cc9ef0db26390cdda25044020b3c5cc7f666fd3cf898982767f3ec420"
    sha256 cellar: :any,                 x86_64_linux:      "7ae348977b6982c4d0822472acc2508bbd45e17a320fa647c35bab8ec16c6a82"
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