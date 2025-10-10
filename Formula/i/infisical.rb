class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.3.tar.gz"
  sha256 "0e5f76c966401bb5880d1e435d5c9feea52e0255e3cf48c5ec9d2cd708f7b203"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b06b5e7ec604fe6021edf314d3671694e55cce43b0b53ef141c012717ae7162"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7b06b5e7ec604fe6021edf314d3671694e55cce43b0b53ef141c012717ae7162"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7b06b5e7ec604fe6021edf314d3671694e55cce43b0b53ef141c012717ae7162"
    sha256 cellar: :any_skip_relocation, sonoma:        "913c558db00244ca74cbb503cd626cf2e72c9af59ea4d7181137a6aa97530566"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9efab94bdea1fbfe57c7881d6df9270a2c23f2f09515fd527dc31060ffc70eab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fbdcc2acb57c04838ee436489048829af2b9cd08d4f2960120bc3b9a07d2f4a"
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