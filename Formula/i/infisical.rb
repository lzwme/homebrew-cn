class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.50.tar.gz"
  sha256 "cb3ed99a1f36ea438f574b3344e9037622a370e1878b8eb01425b365b29999e1"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6fd1db439e23302fe3dc9405b35d461f84e5c4f7a4f4804fff4689e9e1091399"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6fd1db439e23302fe3dc9405b35d461f84e5c4f7a4f4804fff4689e9e1091399"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6fd1db439e23302fe3dc9405b35d461f84e5c4f7a4f4804fff4689e9e1091399"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b373aee31438e75c4544f54f0855dcda43461d6c8b5ee714bf4db456c86a2b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5f39e5a72ed2f5815b107db219b48ba650f4eb60a366d641c364ea7e60135a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0ddb84990f9587e4c9302998622a7cd9ae2917b6ca6e41f71ba82ac42e0a2bf"
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