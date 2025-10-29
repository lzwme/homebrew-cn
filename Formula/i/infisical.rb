class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.18.tar.gz"
  sha256 "09aa89b88f407e5510a9094ad9172dd61161333a58d25de4895aa1239abbad0f"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7772164a74375d78e4ab413e8304225c52c2e5e5b6e7b33a655f3c296e16f7c0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7772164a74375d78e4ab413e8304225c52c2e5e5b6e7b33a655f3c296e16f7c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7772164a74375d78e4ab413e8304225c52c2e5e5b6e7b33a655f3c296e16f7c0"
    sha256 cellar: :any_skip_relocation, sonoma:        "e96d04f510c8bcc16f2048489f2015fe61fccc8dbd29cab55fb8c83a068a064a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c31c2b73513209bd75d43dc2962e99334e674988e2dcb973bf90bd58421e00a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a6b52ee74b8e10823aa3761613d7b3472d8d743e93db501ad952df47f540669"
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