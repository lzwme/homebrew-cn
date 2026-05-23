class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.86.tar.gz"
  sha256 "3c251d226ac6a80ac4794a265ab761fb5faea377ac06f13f1126987ec5279840"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bdeb74b79580897e586cace3d17ee9c1d57c8394ea5910ad77b17e1db72ab30b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bdeb74b79580897e586cace3d17ee9c1d57c8394ea5910ad77b17e1db72ab30b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bdeb74b79580897e586cace3d17ee9c1d57c8394ea5910ad77b17e1db72ab30b"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ee9105a8066bdf82f7f26f585fd9fed687bee0c68b511222abb9db33a2b24e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d4418c4eccd69f86bba694fa10bee5c7b1c5f727c96f79d1eab9316fae92ad81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b38c71a3d91f9427372bfe1f98c4dadc2a7ec59d8587673af00546f76263c7e1"
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