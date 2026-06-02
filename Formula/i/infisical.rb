class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.90.tar.gz"
  sha256 "fa6b7e355f975e1dfa21e92f18af67c44826a33ae6d984dafb64cdd8021502a5"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4b618b819d68224c2eb1075e6c1ead28dfc76e5e46fa3b34df69e5e614953fd7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b618b819d68224c2eb1075e6c1ead28dfc76e5e46fa3b34df69e5e614953fd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b618b819d68224c2eb1075e6c1ead28dfc76e5e46fa3b34df69e5e614953fd7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0540735813c3998f93f4fefa97ecca57581ecceff54578f062dfdf019d9e5cf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "033cb4fac8b8cadfcf09e1b60e756ddce2d49ba44819d0a35d9afc98ebe76a09"
    sha256 cellar: :any,                 x86_64_linux:  "723127a71565ab947e2bd6966463ed7da2fcad1dcab4ff87293a327c320d0931"
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