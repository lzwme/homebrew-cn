class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.79.1.tar.gz"
  sha256 "a1e8e57e553ae88fb4b5a044d4d74cd7f69779c6dbea14781693559ee4e37e01"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0cfe30f566e7784246ef69b364bfc1c5ced174f551a6fbfc9eb2c712bbf48346"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4aff2ab39c433f2625f94136a2a01f5169ec8fa0c851c91767cc104a5887e734"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "07e0c3ee1052e559ef93e281dad07152295143d8b58d025a0c3ca4da788c8980"
    sha256 cellar: :any_skip_relocation, sonoma:        "2cc8b48c3d8cebb5ff7d75f003752e435aba1e13167037363c4780eadba35daf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3544270cd8ec0ff2e742df392735774364de6e1a877122f96a54be57c8862c5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f3a61908b7992d1ddccb94d5167c93a581336a62c792616845bf9c07b2301a8"
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