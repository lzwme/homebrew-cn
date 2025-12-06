class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.37.tar.gz"
  sha256 "aa57178f9f34afaeb0427d96ed7c500f6fd7a07f16b5cb6ee95e8382d808bad8"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7256a35d5ed630e913e4637a4b0f73517cb12f2ac56b9e1b735faabb0b593592"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7256a35d5ed630e913e4637a4b0f73517cb12f2ac56b9e1b735faabb0b593592"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7256a35d5ed630e913e4637a4b0f73517cb12f2ac56b9e1b735faabb0b593592"
    sha256 cellar: :any_skip_relocation, sonoma:        "626c74518831d9517033034447029ce7b333174ece613a63be98c4e404e614ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "78f46b548c1df11dc3e2963a41f6ec042425fc6ac2e97616ab8776d2127dc37a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "29146b58aa7a48aa09f8112fc031bd91910bff377845e47a993ab3e237ad7eec"
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