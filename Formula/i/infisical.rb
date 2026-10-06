class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.139.tar.gz"
  sha256 "5ab9296f02a93aac4a9ad8241f5ff205803928d852f2a93958b6e81081e59faf"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f7e98ff295f2b2a0eba1c81a7495f91b31561cccea1954fabf6bcf26539f5173"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "f7e98ff295f2b2a0eba1c81a7495f91b31561cccea1954fabf6bcf26539f5173"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f7e98ff295f2b2a0eba1c81a7495f91b31561cccea1954fabf6bcf26539f5173"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e032b63dd7989caeeee903b81aed898201307c9ab411110a95fa08d3a4a132e2"
    sha256 cellar: :any,                 x86_64_linux:      "542550b4404e630335c4a9273d3553e1ab18884140d7b5ceb480ffaffd02bc21"
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