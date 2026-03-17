class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.82.2.tar.gz"
  sha256 "6421daeb15667c94e5b008e917713e81977c885128af7aab9691dd8cd9cd1cb2"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5b031cafb0edfc64e69e49157b047dc6af09cad92acb92f4845768d950a39bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0647dc4ad61e950d8aec986a0afc67e53d0b000ff7192b5e4ab05de763862abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9507b9571e99174810b50a4c5783bfc9a5f76ca819642a0a81cd6bca4724c33a"
    sha256 cellar: :any_skip_relocation, sonoma:        "23b9123117c9dbe93773732ced82393557437d2e5d771822bdb3f231d52f2357"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b93bb4ec8fa1f5dd347394c4fd06b37a3f97e77bf973b2925e6b2bbcb9603cea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "614c2361b8cacb4ea2507b588a5794647afdc4d0b42543aa9a2f53fb46859cf7"
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