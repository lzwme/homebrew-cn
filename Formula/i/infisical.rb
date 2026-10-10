class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.141.tar.gz"
  sha256 "71241bc932a1e867bc428fd9dc3101ac3808c8a45be1045b8195895f0ddd5df0"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f42c02558264235fc34582e227c39d868d24a3d89990bd66fee3fde166f03cde"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f42c02558264235fc34582e227c39d868d24a3d89990bd66fee3fde166f03cde"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f42c02558264235fc34582e227c39d868d24a3d89990bd66fee3fde166f03cde"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "3906904ac7317c97b307cd4006a79646f5a150345bb83a60a43ef0185a121fc0"
    sha256 cellar: :any,                 x86_64_linux:      "ef00a8b5c6482f3a6934718b109a0385ca74ada8807ecca81671d46758d3b639"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"infisical", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end