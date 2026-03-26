class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.62.tar.gz"
  sha256 "d8382da7af988c3a36fd9ebddf12e982baa94ef6868df13e45713f9dce150af9"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5c580cb57ce39119cf1f288688db66bf9fbcdc23d6f2994ec28f6bfc83566a6c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5c580cb57ce39119cf1f288688db66bf9fbcdc23d6f2994ec28f6bfc83566a6c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5c580cb57ce39119cf1f288688db66bf9fbcdc23d6f2994ec28f6bfc83566a6c"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e36e55bcf47009308ca92299ffa0111a5005d4aff2cdcf6c4f7bf713712c93b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1f3b2c05c769fcadb8405f3e69bbbf9d16685aa9b8bbcdd255a6101e3c608e2f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be2346daf8733a8745985954f52af6cca8d1f0e467ab617633547ac78c1bb3d1"
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