class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.14.tar.gz"
  sha256 "6fe326ea95677787cd5e4967944553c6a346ddc9e4db2b7823cae2b7fe9112f0"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea5edb8dd758f635b8a4df3aae5ce070acaf1fa0aa4095133bcada87041153a3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea5edb8dd758f635b8a4df3aae5ce070acaf1fa0aa4095133bcada87041153a3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea5edb8dd758f635b8a4df3aae5ce070acaf1fa0aa4095133bcada87041153a3"
    sha256 cellar: :any_skip_relocation, sonoma:        "45f46ab963516f7d9c77ece0bf45be18095503e68e992ad26ef228a70f0046b7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "da5b53f69ce0702a01e3f80ab3aa9b93e4a1059dc4753a8f2fa722de122f38d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f163a62f356f5e604f7cbc97b05e684c79489d5149a2b060e5ba2300110d604e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Infisical/infisical-merge/packages/util.CLI_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/infisical --version")

    output = shell_output("#{bin}/infisical reset")
    assert_match "Reset successful", output

    output = shell_output("#{bin}/infisical agent 2>&1")
    assert_match "starting Infisical agent", output
  end
end