class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.51.tar.gz"
  sha256 "9ac264686574e05acf4d99bac3fc5f7b5a4694ad1c9c84815b1d99e979110301"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2c5fa4f7ed5bab5ffd1a5b77e020d9bd2d4e33dc9d7c376832726b0cfa3b69a8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2c5fa4f7ed5bab5ffd1a5b77e020d9bd2d4e33dc9d7c376832726b0cfa3b69a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2c5fa4f7ed5bab5ffd1a5b77e020d9bd2d4e33dc9d7c376832726b0cfa3b69a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "04e401b850e8f02fa177f1fe59b33b1f56220f96838c069f96f11cbc97594d4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "885cfba1f0f3c2b6aee1bae504f64e03ea327f197fcd82c392486efa20f045fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "005dc03d131dc63cb7282739182677cbfba0563e7b62f92b8bcbe7423a59ba4d"
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