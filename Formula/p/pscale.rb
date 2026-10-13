class Pscale < Formula
  desc "CLI for PlanetScale Database"
  homepage "https://www.planetscale.com/"
  url "https://ghfast.top/https://github.com/planetscale/cli/archive/refs/tags/v0.345.0.tar.gz"
  sha256 "cea43a2cd4b337fc52773a34f2e32113899454620a00409284aba34811221931"
  license "Apache-2.0"
  head "https://github.com/planetscale/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "7fb1660581e30e64e307331fbf7e749c375f1a96e565be7f9e78ee2dea6398a8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "25c77178ee05cc4b3fb44aabf8e1d7f3b2eb21dff1968ec46c00bee21d081adc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f1c4e21ba7a7edfedd0d696a8c4867267477a08510989644cb2c5ffa5d8695c1"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "9f84c5b7dde5067e607c35436fa4c496b34ebe99e4e060f10b1ff16effac02af"
    sha256 cellar: :any,                 x86_64_linux:      "b71ed7bcf6ebcfe8bfd5e34d594cb2904a9cb53b6f24b012f126f133623043a6"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/pscale"

    generate_completions_from_executable(bin/"pscale", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/pscale version")

    assert_match "Error: not authenticated yet", shell_output("#{bin}/pscale org list 2>&1", 2)
  end
end