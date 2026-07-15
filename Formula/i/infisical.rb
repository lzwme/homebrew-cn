class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.106.tar.gz"
  sha256 "f99d1e3128d80e8918309a4da20f1458e1308f60b4239db9d30bb988ca1b9d88"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b55dff01dc44b8655eea6926d1d5d50118aa511e927e1f159720d704a6790db2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b55dff01dc44b8655eea6926d1d5d50118aa511e927e1f159720d704a6790db2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b55dff01dc44b8655eea6926d1d5d50118aa511e927e1f159720d704a6790db2"
    sha256 cellar: :any_skip_relocation, sonoma:        "467ebb1ef25e35b9a2c6b5f987002e83f2ee10d323c2b9fdc1e4a7733c498982"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "abee9b0717b60b2bed5ccd750fa99d8cc118dd07b864f9a48df6129aed415759"
    sha256 cellar: :any,                 x86_64_linux:  "a92421b0ae889395e04327ae63cba501c7cbd4ae7ca77d466267ee7379f0d247"
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