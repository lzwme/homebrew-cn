class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.122.tar.gz"
  sha256 "b5f9b7fe077afd30c35f47b67de71f6f55d7e0c1c8e30314ed06e31612a794e3"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3eef9a19285100a210866d1f5c30adf86f9933bda5c23a0384d78d5a9fb4e331"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3eef9a19285100a210866d1f5c30adf86f9933bda5c23a0384d78d5a9fb4e331"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3eef9a19285100a210866d1f5c30adf86f9933bda5c23a0384d78d5a9fb4e331"
    sha256 cellar: :any_skip_relocation, sonoma:        "a1e5cb758dac09c65b4a41384542e64958701a189e0e7d695da1c004a8df93b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a7945f2c214a12b98f1d6a7f09400151e4b84e68c729636ad948bdc15b24e409"
    sha256 cellar: :any,                 x86_64_linux:  "5285f5aa362535df2397206b1cd4b2ac06f2db00a48ababaea27f99346382240"
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