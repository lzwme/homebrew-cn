class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "ae29f04e40855560d8e6fa6afd417eaf331dc622d9651cc0932b192df917dd28"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "600c7359fdf783528fb070e8baad2eac7b3fe1d2092a02cef6fcdf05b00e1ea5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c4835dd36e6f6255bc1c9caff1983b629893aa41e8ae8003f59c38f4f5140cb0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "224f1b560605bef2c52287ca61763977b4f075db6c883c34e9a701aaa6142a17"
    sha256 cellar: :any_skip_relocation, sonoma:        "f24eabd27c483b47519ccd863fc9723a39015b382ce4553bba0cfc8421d04f3b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "16117adfbef57be711c5cd053028b1818f5ad1c77f88f5d14eeab365730ecb9e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e473e61eba66d520ee4317bd1e2821d73212c3464d9de70cbf070c78ccbb00f"
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