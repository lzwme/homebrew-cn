class Infisical < Formula
  desc "CLI for Infisical"
  homepage "https://infisical.com/docs/cli/overview"
  url "https://ghfast.top/https://github.com/Infisical/cli/archive/refs/tags/v0.43.2.tar.gz"
  sha256 "67b75b4cc3a822e099098c4bcc714a94814db9bf76e397701abb4a1b09e21858"
  license "MIT"
  head "https://github.com/Infisical/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "33e55bfafe232df892d4b66084197b79bce7aef0dca14c98ff0fd0398ba5dc19"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "33e55bfafe232df892d4b66084197b79bce7aef0dca14c98ff0fd0398ba5dc19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "33e55bfafe232df892d4b66084197b79bce7aef0dca14c98ff0fd0398ba5dc19"
    sha256 cellar: :any_skip_relocation, sonoma:        "249bc0c7fe5bcab226b290688cd7d09ab3617aa2fca10cc64e7a793c7469ddad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8084ad3a63cf01669a705645d297060cb555b2a072e995a2cedaac83ce4d521"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a0f7b8f2bf7e36a97b36e8da165afea2c11f03bd7bbd9d1b52831c791ea6eda2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux? && Hardware::CPU.arm?

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