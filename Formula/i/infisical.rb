class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.100.tar.gz"
  sha256 "117ab08be0e45ca653530b69529cb0f8ef86a454ac5c9142845915b1d892fd3f"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dafdc8e45838978a8c8b79535568af5fc6a623e4a34694e868bae97f0b058277"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dafdc8e45838978a8c8b79535568af5fc6a623e4a34694e868bae97f0b058277"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dafdc8e45838978a8c8b79535568af5fc6a623e4a34694e868bae97f0b058277"
    sha256 cellar: :any_skip_relocation, sonoma:        "635c0277a7bcfb64dfc852fa9d8d5d18c1e8bd2ba85d23fcdad8ba2f534dde23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "eb45b2c60e36e97ba4b8e3b1b49ae02796500e33e5dd090022f63a0473b62e17"
    sha256 cellar: :any,                 x86_64_linux:  "b36a31d024c70860f1187cf4149a01a6e2830b199e8919e1f251316c81ba37ee"
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