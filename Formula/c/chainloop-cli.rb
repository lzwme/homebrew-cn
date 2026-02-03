class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.74.0.tar.gz"
  sha256 "f4c91a95cd6b08cb17578c9b30c8f9d394ace1b7cc1f877d864fcc72566a2ade"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d46772a73e189a16fba8b212e0e9364a3e1968989c8187b88907b642fbcc0f37"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "280c8ada9bae707ead8e9d9a4c0a6a81dd4d62a833d3aec9c7c17e0eb6985610"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "981e3e9f8b2d3cdaff06a5050d799183b857b16fbfc0dd3d815ac274447b3576"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb5a1e51284c29172c740cd69972ec27989e6593d7f0e58cecc8a5d8fd13622f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1256ef3c930d382cbe8b049eddcecee93227296bbb79db5494b882d6b25429f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07079ea1d0897fc5a62feb2ea26c36b0547eca4c987fa8fa41701c186f1dd5d9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end