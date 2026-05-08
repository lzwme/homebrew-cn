class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.81.tar.gz"
  sha256 "d84c5da0d3903084e3589c910f48f831e32bf80c605f6ee687a85631a7fdac1b"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ca922e0271093f59353ee7bf7efc3509ea16cf83f5e556829f19b3fc0ea37a6f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ca922e0271093f59353ee7bf7efc3509ea16cf83f5e556829f19b3fc0ea37a6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ca922e0271093f59353ee7bf7efc3509ea16cf83f5e556829f19b3fc0ea37a6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "dda4b26ff43e9b34f1a53f2037c583bd169b7538f8898454fcdb8e4b2173f015"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d1f6b0b2b45ce38d81d8605e52a4d775f991c5724812cff1e5b8a72907f40179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b5692f7c38ad81521284469c2d64b1318778e971ddc220d320ce378983049c72"
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