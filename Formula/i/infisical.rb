class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.87.tar.gz"
  sha256 "291b66dfeeddaa2e15fbeb506ef6007b7c88a054473e0fbe1567754257887ceb"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3202f5ee1d27d200b3e9f09aa393d6d536dae3e4fcfec801ed00f4fa925e6186"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3202f5ee1d27d200b3e9f09aa393d6d536dae3e4fcfec801ed00f4fa925e6186"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3202f5ee1d27d200b3e9f09aa393d6d536dae3e4fcfec801ed00f4fa925e6186"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c186c98841703c639fc5e091dc358968ba787815a1ced6c3cf0b882456b187f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4869a25eed93f8fee5b05a27a9c02a8d9df09328d1bdc5dffc6521ffa53ad777"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d3e7753ed5a49eb16095e0e0bd77a1bcb734f0e39ebafe5655d64ee15eb87c90"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
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