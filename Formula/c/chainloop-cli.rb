class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "d0fe0daa81099b447dadf236d8eee2b8aa2677f9d636d0accd9a2936c694ffb3"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f417c9d71dcdcd538af0198975b256b2809775072ebe2a492611f176a28ddb28"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be46ba39a1750abfb175a503b0698b29980b3128a363f32604a6002ae3cfb2ec"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "40e7538fc2504145db9b93b3af488f36601002fc6e9d658b787aec8074d827a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "c94e73b111a9c997ed464cc91cedcb57475c7052fc70a25aba9a33da648d7397"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a809d8a01d867bcc0fed321337a772063b46e3c0a6761c7bf347ff2b2ccfeb55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "802834bbe1a5c21b0e0a4967f4e7a7aac1d1d3395bb901acb415b802d853f25e"
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