class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.65.tar.gz"
  sha256 "6137e353ac96a9388a52fe7b0a8af651a1b6feac3835c5fdcf004a7c7e942be9"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa2e9f15a8cb8ab6782f0d1fa066617d9be1ac70ee77e838a61cad51c3f816ff"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa2e9f15a8cb8ab6782f0d1fa066617d9be1ac70ee77e838a61cad51c3f816ff"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa2e9f15a8cb8ab6782f0d1fa066617d9be1ac70ee77e838a61cad51c3f816ff"
    sha256 cellar: :any_skip_relocation, sonoma:        "293a0a52fb8f1a100befb662c052b25541ea59ad10219d3bf3c371fa1a9d1aa2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78d19edd3d110e8cc922374525a151186409d4e4dcdd12d4c02adc863f0a2735"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3884a9f23af7c06965ad713b5c11523a5ca1c5f148365c394f2d296095fa644e"
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