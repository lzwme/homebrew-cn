class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.36.1.tar.gz"
  sha256 "6bee747e9860607b779ced90b95cd0f0334cde8d8b0b75323679d6fa3b994ade"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "227576812c940aef47ed02353fc1fc7799dd4e6d58d1a79de14164f7eb7144ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec38333ca0561937c401854dd73965053579d8dcb9f4a89501f5014756c6f58f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e4f5337a780233d43494a09329be5aeef64187254022cfdb5a9d34698d8d7bf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "c303e901a2a49c8445ed4d94aba6e7098a689345a8837192fbf6455bc7973948"
    sha256 cellar: :any_skip_relocation, ventura:       "71392828c82cef14cd127089cd51b6f19924054871651f5575523c44603b5523"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "023903a95d7375184626f4a514f553ce87c2b44ab90277a4bc4b12ec3b3acf78"
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
    assert_match "authentication required, please run \"chainloop auth login\"", output
  end
end