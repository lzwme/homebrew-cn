class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.97.tar.gz"
  sha256 "f36c0369b70420252de246a9b2ebae7d41d8556f5608ff576df0e489decc915c"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d25357f29138b4c4b5fe925bb16183682308340aee3277747ca07acfaefbd7a6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d25357f29138b4c4b5fe925bb16183682308340aee3277747ca07acfaefbd7a6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d25357f29138b4c4b5fe925bb16183682308340aee3277747ca07acfaefbd7a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "6cd4c4e15c64a91d7209a10242368e382035dcf873bd6f221b7d719170bcbee6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b61910ee20e5ee6c1977d373ec88dda73d691f8bbd9be3bcac51c4d0080ca9f1"
    sha256 cellar: :any,                 x86_64_linux:  "5b2d8cff04f1f1f92d97812aed8a4173eb54ee226d8507c7995306f0987c737f"
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