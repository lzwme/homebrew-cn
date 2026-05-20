class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.98.1.tar.gz"
  sha256 "50fe490c0f23009a176693d1ed21adca24e65a7ba45e9b793c8e1eeadac2c24c"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "493078a627bba5a485cdd803b7a5c75868a4caf6bcc9d725f141733c5f940397"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c509f8def48eb150c3896f4f2a9c7d6ef1869e69bcde763480d01fc58f8d92bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd8d8aebaaf614f1c2e55c6be02bacc1b953a87162d875eee886a6db4e392213"
    sha256 cellar: :any_skip_relocation, sonoma:        "7cd608cd256d37fcf649cde08da9a8f8180237c464e4c5d7f37afe78036ce711"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a88c649da3607651f4dd75dc07500a9ef124860b73ffd114a8b14976699007d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e70790af775c749f31dbaf300175c91c81ebe3ae96d29d049f15e78b881eafa"
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
    assert_match "chainloop auth login", output
  end
end