class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.89.4.tar.gz"
  sha256 "42e62b4642439d942032b97a94ba9e874d07132ecf8b23e839be7e94be972af0"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c9cb847481b275d6bfb81ec149d1332f6486105dfe05f8c9b2a65d1deb96f307"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d1224f9a02dcac555a3ebe3f5280166b6b0c2d659c1a059c2abffd9ff193ecf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57e5c3cdfc8c2331474cc742ea74549be003a17b86c6b858f3315e5e8ae8cb4c"
    sha256 cellar: :any_skip_relocation, sonoma:        "4506dc1bb2b255f1f7916167bd85e13b280a525918f4f438f9dcd9e78393731e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "789a466f6a47047963fa11b76335a62ca63daa0e8abc4846f1c8626b5d81dbb6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af3f052d857aa5c604d47639dc4d6b07a1a4cf0aa893c0565e2273bcc4914b9e"
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