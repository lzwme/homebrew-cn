class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.143.0.tar.gz"
  sha256 "4b5baf6d02043bbeacbf0bbbf71c4cf10ac15c1e5dd84a4b7afe5fa75dcc80ba"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5d136546d1d10eac8e15d44a7aedca7816c4d18b0286b5871c3f416d708fc6c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5d136546d1d10eac8e15d44a7aedca7816c4d18b0286b5871c3f416d708fc6c8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5d136546d1d10eac8e15d44a7aedca7816c4d18b0286b5871c3f416d708fc6c8"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d87d7d2c6ae6f9f9bdbe6d1ff36a0f99c3bf5b8e58b1a2ab259b3b1c33d783a"
    sha256 cellar: :any_skip_relocation, ventura:       "821e5462b2212e9c342b0373dc114e4de9d631487712bd75355bfe6847f443a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76c789e16caa89c4790ad0a07e6f8f7c140c648c9b45c1f50b6b4421b2ac8cf9"
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