class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.123.tar.gz"
  sha256 "a8515377eb0801f02eb6ac21c85b922a01bf78b59bab3b6a8609138c3a445785"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "644b5905dad8bec215c9e56f1e0e3ffcd65bf3bac8111fc53357b0f50b40d9c1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "644b5905dad8bec215c9e56f1e0e3ffcd65bf3bac8111fc53357b0f50b40d9c1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "644b5905dad8bec215c9e56f1e0e3ffcd65bf3bac8111fc53357b0f50b40d9c1"
    sha256 cellar: :any_skip_relocation, sonoma:        "3006cea1aff1caab83bb110806c4d8a84c626af01c6c06d7205efc30d10857d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e40a0b208728405fc4663c24dff896df8c983aebd599ad4b42004fbaabfddfd2"
    sha256 cellar: :any,                 x86_64_linux:  "d476fba7fd476c7a9f76e59610afd6240839f626568270db850e1bde68aeb2c7"
  end

  depends_on "go" => :build

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