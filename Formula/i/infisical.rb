class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.24.tar.gz"
  sha256 "f8a16a01e5efdc495b6e480f204eb744441e3a4ebb15d0754ffe36801aa636f8"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7f4cab2a012ba524a85650448ac78ca43f42a331584e970953cdd571838edc25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7f4cab2a012ba524a85650448ac78ca43f42a331584e970953cdd571838edc25"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7f4cab2a012ba524a85650448ac78ca43f42a331584e970953cdd571838edc25"
    sha256 cellar: :any_skip_relocation, sonoma:        "d6bc3df54c9850e57e7377d1af95538a891fe2d4fbe59ff083cdc594a6bd47fd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a06563e11a3d6a4c41b3349367f5d6a43fed6fc9b63ede124fd64cea7746236"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "367e867f58076d35c752775a629c9643439110d785ab31333eb8ace71e81e106"
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