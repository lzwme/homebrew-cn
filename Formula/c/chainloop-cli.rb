class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.113.0.tar.gz"
  sha256 "2f562e8e6f8cd0150c6a2bf48f665ab028f7998616054721215b795562df70b0"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4405e603c4d60415a41b0509f1b963b34bcb8a8f3241b603cad56de425974f59"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4405e603c4d60415a41b0509f1b963b34bcb8a8f3241b603cad56de425974f59"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4405e603c4d60415a41b0509f1b963b34bcb8a8f3241b603cad56de425974f59"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b4ea22729d3ada5624a6d47c0a4738f1f4804c8596bc4a8185453a2459148f6"
    sha256 cellar: :any_skip_relocation, ventura:       "4dbee3e088ba6025fe82ec5edd2b8a91a95649c327e54c2da3035397d496189d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b01b73222193c4cf5bf7fe9f8bf5b4bcc4b2db737af6b1f57975b8c15962e9f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comchainloop-devchainloopappclicmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags:, output: bin"chainloop"), ".appcli"

    generate_completions_from_executable(bin"chainloop", "completion", base_name: "chainloop")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}chainloop version 2>&1")

    output = shell_output("#{bin}chainloop artifact download 2>&1", 1)
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end