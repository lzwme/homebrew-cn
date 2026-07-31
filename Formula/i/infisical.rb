class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.115.tar.gz"
  sha256 "45f530b316ccd3a0b33e0858288a17ae0c0f0a978fe099815a9940cf9691faee"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b6fb3305d6c4b0f703489831c578e3854aae7a9ebd9c77390f7dad1d56405209"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6fb3305d6c4b0f703489831c578e3854aae7a9ebd9c77390f7dad1d56405209"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b6fb3305d6c4b0f703489831c578e3854aae7a9ebd9c77390f7dad1d56405209"
    sha256 cellar: :any_skip_relocation, sonoma:        "8f6b4985cf9783583a6ceee83a5d0d8abbab77d0a6889a8149da53e15f149cf4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6ba87f30b5e0e746a46096ac16a407e72e4ae4bf71ac3f1a858bb09579194a28"
    sha256 cellar: :any,                 x86_64_linux:  "de29479d7428107bcb3139cfd6337e025d6b3ae632448eca0cff0165046f5341"
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