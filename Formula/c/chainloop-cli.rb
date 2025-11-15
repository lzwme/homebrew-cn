class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.57.0.tar.gz"
  sha256 "9be141c9cfe4517e818102e77ded6a0a03f81cafe14ba92562f2be7533b1607e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4779c3fa500f6a26607ee5e6f951eae6dce8f681c48df29e665a12a8f22f6c4e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "08b47b31b3e8ab61e4f81a8d387949bd50bfe383fb09fb73fa751db8716f7401"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c4d64888676234ba61c42497edfed1e5d9e336a153745b87c88fa9020533f7c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "9ad74728d53e20e24d6fcea6bab9b78a8c24480740b0f799373b5cde1b6cace3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6f3d1a62b2604b75f785e830a0a1a014426f7a6135984aafbbc93cbaecd0c8fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a77becfe2fb7a84df5f20cda6e6f3ed77d9ac6867bdd79472b1df2ca3f51af9f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/chainloop-dev/chainloop/app/cli/cmd.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:, output: bin/"chainloop"), "./app/cli"

    generate_completions_from_executable(bin/"chainloop", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/chainloop version 2>&1")

    output = shell_output("#{bin}/chainloop artifact download 2>&1", 1)
    assert_match "run chainloop auth login", output
  end
end