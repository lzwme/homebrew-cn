class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.96.3.tar.gz"
  sha256 "09237477f4afb9be094ea051a4788cca45f630ee2b3aa18f2937f6c0a59bd22f"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "80bd0603303ea13111dfdf37caddaf4b3b4359725a76dadb34f98266e61c7a6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80bd0603303ea13111dfdf37caddaf4b3b4359725a76dadb34f98266e61c7a6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80bd0603303ea13111dfdf37caddaf4b3b4359725a76dadb34f98266e61c7a6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "156ae7ab7569c65519380c60a0c155855ca5e67cfae04f04614ea08e01e05ae9"
    sha256 cellar: :any_skip_relocation, ventura:        "9e981d4a03152a2cc012a24a72e56468039f3747ec808964b8d76bbdb8310f16"
    sha256 cellar: :any_skip_relocation, monterey:       "12a7fc4a85911e5d0839121834da078136d3db807ce2bfac5125bbb2afd9c424"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f92498c3c9ead918a09ec43a00180737a002d0f590e5139c46dce294fccffdaa"
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