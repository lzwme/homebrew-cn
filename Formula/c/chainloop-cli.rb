class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.111.0.tar.gz"
  sha256 "42933afb8b73dc34115bca1ce47bab75be210ada55a1a02e374d3aa7359d62ea"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "786f42749f4681b09416c4b55ae02e516cea53be06df4eafc9549b3a863c2dbb"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "786f42749f4681b09416c4b55ae02e516cea53be06df4eafc9549b3a863c2dbb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "786f42749f4681b09416c4b55ae02e516cea53be06df4eafc9549b3a863c2dbb"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "8f35ac102db2fcf3dc2b8ca50456e18ffe754925a721ed5aa427100f48745212"
    sha256 cellar: :any,                 x86_64_linux:      "ece47e315cce6f2b1e2adbe602a9360342d1f50beec3c49a9f8e04056ee51b2c"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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