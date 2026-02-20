class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.57.tar.gz"
  sha256 "721a19f4aa68fea47ecb9f1b6021c93a383de0145e93ee37e52973ea9c37bd5e"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0f5aae3044c75a8c82367a9da19ec42bded711e63bdd3eed021f2bbc368cade6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0f5aae3044c75a8c82367a9da19ec42bded711e63bdd3eed021f2bbc368cade6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0f5aae3044c75a8c82367a9da19ec42bded711e63bdd3eed021f2bbc368cade6"
    sha256 cellar: :any_skip_relocation, sonoma:        "9c3b66290d0586e7e89752d90e74d8de3c518a1dec2b0ec49fc92336d97282d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0ba883935a44b40b6fa7c47f24d447d3ea29f02a29cfeb9a3b78e22a317e4162"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46889b52b7b3d937cd524a24e67c20bdf9be6aa804d13c2109e205e364c9a4c8"
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