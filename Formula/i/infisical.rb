class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.118.tar.gz"
  sha256 "a02006908db9629b0622df8012925861a83c02082457cf57b450d3a06b2582b6"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4c78aa44e56d783e5b4b94f1425ec90165da5c8df0793cbfd56403a3fad30634"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c78aa44e56d783e5b4b94f1425ec90165da5c8df0793cbfd56403a3fad30634"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4c78aa44e56d783e5b4b94f1425ec90165da5c8df0793cbfd56403a3fad30634"
    sha256 cellar: :any_skip_relocation, sonoma:        "45fd94b58827db01f8428b2cb80cd82a62d8b5515ba51537889ef84851df11c8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8c7a43e3d0e6659c2b4529fd5c7d00527ed9cbd2c5f24be25f3ae1cd161d2d7b"
    sha256 cellar: :any,                 x86_64_linux:  "3f5c32a23da430bc6834dd0e0ee1cc76a3fd3c0d33122bdc98e458affdb03421"
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