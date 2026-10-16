class Oasis < Formula
  desc "CLI for interacting with the Oasis Protocol network"
  homepage "https://github.com/oasisprotocol/cli"
  url "https://ghfast.top/https://github.com/oasisprotocol/cli/archive/refs/tags/v0.22.0.tar.gz"
  sha256 "442367d23ba1185bf5108a7f19a4b845b62b2361a5ba112420d88b9d6dd704a8"
  license "Apache-2.0"
  head "https://github.com/oasisprotocol/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "198a7734db9d69e93ca25b1ec9ed0141360ee0ea1c10c407ff82233e0375a30b"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8bcde26c4184feeb10e90bbf4d6ad65efc9575642a39216431beabf74f2b47e2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "cb8d41072c82283b4616ae4f09a58974f187e7f764f5229de0963f2ff73e1fe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "96bf770793c447fa2b1f8e45a6f5ad2ef20cbfdd13aac4a317ac9c24ae7039a5"
    sha256 cellar: :any,                 x86_64_linux:      "a4ec3fe0488bf15ef8082c536d448f5d6144c7b3dd20c1e8863a0225a0a6a97f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/oasisprotocol/cli/version.Software=#{version}
      -X github.com/oasisprotocol/cli/cmd.DisableUpdateCmd=true
    ]

    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"oasis", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oasis --version")
    assert_match "CLI for interacting with the Oasis network", shell_output("#{bin}/oasis --help")
    assert_match "Error: unknown command \"update\" for \"oasis\"", shell_output("#{bin}/oasis update 2>&1", 1)
    assert_match "Error: no address given and no wallet configured", shell_output("#{bin}/oasis account show 2>&1", 1)
  end
end