class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.110.1.tar.gz"
  sha256 "e4f6f5cd80b3f6beed1af6370dc01c5787856eaa58827ec0db9209b34ac1333c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9edb7a8a496b9b7358a869d62d9a1c22c77c4bd72208f726580e5bbf370f9278"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9edb7a8a496b9b7358a869d62d9a1c22c77c4bd72208f726580e5bbf370f9278"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9edb7a8a496b9b7358a869d62d9a1c22c77c4bd72208f726580e5bbf370f9278"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47aaa82676046c5e17f0877e707e34f355d45773574b63cf1a8eae6c1cb576f0"
    sha256 cellar: :any,                 x86_64_linux:      "14484d6a3b520fb227207714b861a42c4cef0dfb70b0f43f05d81bf8c8259b5c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "chainloop auth login", output
  end
end