class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.31.tar.gz"
  sha256 "63aa0599c4d51d94ec95ced647e822f1a0596ec8144b55fbdf9540e61a3a6d5d"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "28f0fdea844e544a1edcf6309cc8cfe226edfba5c92618de7caf7ab698ee65d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28f0fdea844e544a1edcf6309cc8cfe226edfba5c92618de7caf7ab698ee65d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "28f0fdea844e544a1edcf6309cc8cfe226edfba5c92618de7caf7ab698ee65d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "77fe039d88fa5b767e21d1ca94e479464f47879c97c51a5cc812effa0df0e7b5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d9ee8540a51c2f2be017e462682824f02f7b20e181b05cf359b1e664d0bff1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8599c8c0cc10d0b5d330d0bcd3c7bf0752b61d6236d0dabfd435871aae0c7141"
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