class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.120.tar.gz"
  sha256 "7c2fd91a5a866aab841e57c36e1541a89452a38c273b30ab918e802c83ea37cd"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a27d85492c4ff9cfe0eae74e9755f25b5ac78d7c507ba917ecb1bbd598051ffb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a27d85492c4ff9cfe0eae74e9755f25b5ac78d7c507ba917ecb1bbd598051ffb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a27d85492c4ff9cfe0eae74e9755f25b5ac78d7c507ba917ecb1bbd598051ffb"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e04dabb7e49a9f2bb0bf11c8cd35191920c4d0501c5d8b5acf08d7ee77856a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1bae28fce7a3e9e1596881df691ee76129f7a8f8bd0293379684ead79c04811"
    sha256 cellar: :any,                 x86_64_linux:  "b538c1c61e2c332ab43446a11b8334efc33cc20f7508e13e79eb54ace19fb584"
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