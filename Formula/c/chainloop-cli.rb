class ChainloopCli < Formula
  desc "CLI for interacting with Chainloop"
  homepage "https://docs.chainloop.dev"
  url "https://ghfast.top/https://github.com/chainloop-dev/chainloop/archive/refs/tags/v1.111.1.tar.gz"
  sha256 "43022eebdc9bc8fad9d5bbbcb8733c2debf3752faba8c6978c7e385201ace54e"
  license "Apache-2.0"
  head "https://github.com/chainloop-dev/chainloop.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "757f4155a2f41fb6551de50a8e3ff228a6225ea9e535f6e13916a53ead998339"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "757f4155a2f41fb6551de50a8e3ff228a6225ea9e535f6e13916a53ead998339"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "757f4155a2f41fb6551de50a8e3ff228a6225ea9e535f6e13916a53ead998339"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b527b325f586952d5c4f9a3cbb9ae5387a1eabe3bd94a41ff06b33b0b1dc13e5"
    sha256 cellar: :any,                 x86_64_linux:      "d36d15588bac957bd5595d8267393f70c9440dcf0f11d631780bb5503923ce86"
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