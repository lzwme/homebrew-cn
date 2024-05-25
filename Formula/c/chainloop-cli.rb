class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https:docs.chainloop.dev"
  url "https:github.comchainloop-devchainlooparchiverefstagsv0.89.0.tar.gz"
  sha256 "cedfd6b8904ea20a2fec2a0343be846577551ed1c980111edf333a1a72f41b73"
  license "Apache-2.0"
  head "https:github.comchainloop-devchainloop.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "09be779c8b5bdebde81e561cad612fbaef59c5344361c5a367b72619557dadca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f25638b69cfed9a88169f69589bf8d96dbdf5407658e32618066800af70c7637"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eededc5f2222a51440932478e47b2dd706bef579bafb67a4ff4f36fd5064a5a4"
    sha256 cellar: :any_skip_relocation, sonoma:         "91745580fb635e2d086b9be0ea923591f5a24bcbb21e01359e641db22af7d066"
    sha256 cellar: :any_skip_relocation, ventura:        "0ee2aa82a73b3d8842f64d3871be065e682abaf21470137d3c06c4a566bda906"
    sha256 cellar: :any_skip_relocation, monterey:       "fb454e46e53b78c65662432d33cfa8e15a9323a9569e20d62d8ec073f233187d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "913443509eec980bcfa92e8c1112ae9f333de52a1e333eafbfcf040162383dcc"
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