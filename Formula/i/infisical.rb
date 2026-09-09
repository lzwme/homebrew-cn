class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.130.tar.gz"
  sha256 "e9ccfb6f899b80a73a2b7fcc514909f95e073cd4a33e221209e6c5f62c65ba58"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db573af057415c30cf09954fb8ba048ff4026056417eb44d18049bd185ef075f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db573af057415c30cf09954fb8ba048ff4026056417eb44d18049bd185ef075f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db573af057415c30cf09954fb8ba048ff4026056417eb44d18049bd185ef075f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7722a0727c8166f8fd07c83014cc700fa69a5e5d6a94024e0d9fdb00d9da48f0"
    sha256 cellar: :any,                 x86_64_linux:  "dc13fd59e578eac89a75aee11af5726f59a4629f9044c0bad05492863b685146"
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